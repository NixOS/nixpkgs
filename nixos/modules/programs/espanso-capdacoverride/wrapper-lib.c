#include <stdio.h>
#include <string.h>
#include <unistd.h>

static const char from[] =  "/proc/self/exe";
static const char to[]   = "@to@";

ssize_t readlink_wrapper(const char *restrict path, char *restrict buf, size_t bufsize) {
    if (strcmp(path, from) == 0) {
        printf("readlink_wrapper.c: Resolving readlink call to '%s' to '%s'\n", from, to);
        size_t to_length = strlen(to);
        if (to_length > bufsize) {
            to_length = bufsize;
        }
        memcpy(buf, to, to_length);
        return to_length;
    } else {
        return readlink(path, buf, bufsize);
    }
}
