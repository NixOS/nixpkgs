#include <math.h>
#include <stdio.h>

int main() {
    if (@available(macOS 15, *)) {
        printf("%f\n", (double) __sqrtf16(2));
    } else {
        printf(":(\n");
    }
}
