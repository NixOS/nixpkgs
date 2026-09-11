#include <datatype99.h>

datatype(Number, (NumberValue, int));

int main(void)
{
	Number number = NumberValue(42);
	match(number) {
		of(NumberValue, value)
			return *value != 42;
	}
	return 1;
}
