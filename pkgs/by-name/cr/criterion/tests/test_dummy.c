#include <stdbool.h>
#include <criterion/criterion.h>

Test(test_dummy, always_succeed)
{
    cr_assert(true);
}
