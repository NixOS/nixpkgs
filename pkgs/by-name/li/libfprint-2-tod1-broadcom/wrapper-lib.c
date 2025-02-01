#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static const char from[] =  "/var/lib/fprint/fw";
static const char to[]   = "@to@";

FILE* fopen_wrapper(const char* fn, const char* mode) {
    size_t fn_len = strlen(fn);
    size_t from_len = strlen(from);
    if (fn_len > from_len && memcmp(fn, from, from_len) == 0) {
        size_t to_len = strlen(to);
        char* rewritten = calloc(fn_len + (to_len - from_len) + 1, 1);
        memcpy(rewritten, to, to_len);
        memcpy(rewritten + to_len, fn + from_len, fn_len - from_len);

        printf("fopen_wrapper.c: Replacing path '%s' with '%s'\n", fn, rewritten);
        FILE* result = fopen(rewritten, mode);
        free(rewritten);
        return result;
    }
    return fopen(fn, mode);
}
