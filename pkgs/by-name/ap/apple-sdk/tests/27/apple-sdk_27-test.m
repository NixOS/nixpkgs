#include <sys/unistd.h>
#include <stdio.h>

int main() {
    if (@available(macOS 27, *)) {
        int ret = dup3(1, 3, 0);
        if (ret < 0) {
            printf("dup3(1,3,0) failed with error\n");
            return -1;
        }
        dprintf(3, ":)\n");
    } else {
        printf(":(\n");
    }
}
