#include <metalang99.h>

#define factorial(n) ML99_natMatch(n, v(factorial_))
#define factorial_Z_IMPL(...) v(1)
#define factorial_S_IMPL(n) ML99_mul(ML99_inc(v(n)), factorial(v(n)))

ML99_ASSERT_EQ(factorial(v(4)), v(24));

int main(void)
{
	return ML99_EVAL(factorial(v(5))) != 120;
}
