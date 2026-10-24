#include <interface99.h>

#define Shape_IFACE					\
	vfunc(int, perim, const VSelf)			\
	vfunc(void, scale, VSelf, int factor)

interface(Shape);

typedef struct {
	int a;
	int b;
} Rectangle;

int Rectangle_perim(const VSelf)
{
	VSELF(const Rectangle);
	return (self->a + self->b) * 2;
}

void Rectangle_scale(VSelf, int factor)
{
	VSELF(Rectangle);
	self->a *= factor;
	self->b *= factor;
}

impl(Shape, Rectangle);

int main(void)
{
	Shape shape = DYN_LIT(Rectangle, Shape, { 5, 7 });
	VCALL(shape, scale, 2);
	return VCALL(shape, perim) != 48;
}
