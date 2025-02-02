class StringCalculator
  def add(numbers)
    return 0 if numbers.empty?

    delimiter = ","

    if numbers.start_with?("//")
      parts = numbers.split("\n", 2)
      delimiter = parts[0][2..]
      numbers = parts[1]
    end

    numbers = numbers.gsub("\n", delimiter)
    num_array = numbers.split(delimiter).map(&:to_i)

    negatives = num_array.select { |n| n < 0 }
    raise "negative numbers not allowed #{negatives.join(",")}" if negatives.any?

    num_array.sum
  end
end

require 'minitest/autorun'

class StringCalculatorTest < Minitest::Test
  def setup
    @calculator = StringCalculator.new
  end

  def test_empty_string_returns_zero
    assert_equal 0, @calculator.add("")
  end

  def test_single_number_returns_itself
    assert_equal 1, @calculator.add("1")
  end

  def test_two_numbers_returns_sum
    assert_equal 3, @calculator.add("1,2")
  end

  def test_multiple_numbers_returns_sum
    assert_equal 10, @calculator.add("1,2,3,4")
  end

  def test_newline_as_delimiter
    assert_equal 6, @calculator.add("1\n2,3")
  end

  def test_custom_delimiter
    assert_equal 3, @calculator.add("//;\n1;2")
  end

  def test_negative_numbers_raise_exception
    error = assert_raises(RuntimeError) { @calculator.add("1,-2,3,-4") }
    assert_equal "negative numbers not allowed -2,-4", error.message
  end
end
