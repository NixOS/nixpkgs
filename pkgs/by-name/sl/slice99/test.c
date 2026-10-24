#include <slice99.h>

int main(void)
{
	Slice99 str = Slice99_from_str("hello, world");
	return !Slice99_primitive_eq(Slice99_sub(str, 3, 10),
				     Slice99_from_str("lo, wor"));
}
