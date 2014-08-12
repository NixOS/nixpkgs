#define _GNU_SOURCE
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <limits.h>
#include <string.h>

#define MAX_REDIRECTS 128

static int nrRedirects = 0;
static char * from[MAX_REDIRECTS];
static char * to[MAX_REDIRECTS];

// FIXME: might run too late.
static void init() __attribute__((constructor));

static void init()
{
    char * spec = getenv("NIX_REDIRECTS");
    if (!spec) return;

    unsetenv("NIX_REDIRECTS");

    char * spec2 = malloc(strlen(spec) + 1);
    strcpy(spec2, spec);

    char * pos = spec2, * eq;
    while ((eq = strchr(pos, '='))) {
        *eq = 0;
        from[nrRedirects] = pos;
        pos = eq + 1;
        to[nrRedirects] = pos;
        nrRedirects++;
        if (nrRedirects == MAX_REDIRECTS) break;
        char * end = strchr(pos, ':');
        if (!end) break;
        *end = 0;
        pos = end + 1;
    }

}

static const char * rewrite(const char * path, char * buf)
{
    for (int n = 0; n < nrRedirects; ++n) {
        int len = strlen(from[n]);
        if (strncmp(path, from[n], len) != 0) continue;
        if (snprintf(buf, PATH_MAX, "%s%s", to[n], path + len) >= PATH_MAX)
            abort();
        return buf;
    }

    return path;
}

/* The following set of Glibc library functions is very incomplete -
   it contains only what we needed for programs in Nixpkgs. Just add
   more functions as needed. */

int open(const char * path, int flags, ...)
{
    int (*open_real) (const char *, int, mode_t) = dlsym(RTLD_NEXT, "open");
    mode_t mode = 0;
    if (flags & O_CREAT) {
        va_list ap;
        va_start(ap, flags);
        mode = va_arg(ap, mode_t);
        va_end(ap);
    }
    char buf[PATH_MAX];
    return open_real(rewrite(path, buf), flags, mode);
}

int open64(const char * path, int flags, ...)
{
    int (*open64_real) (const char *, int, mode_t) = dlsym(RTLD_NEXT, "open64");
    mode_t mode = 0;
    if (flags & O_CREAT) {
        va_list ap;
        va_start(ap, flags);
        mode = va_arg(ap, mode_t);
        va_end(ap);
    }
    char buf[PATH_MAX];
    return open64_real(rewrite(path, buf), flags, mode);
}

FILE * fopen(const char * path, const char * mode)
{
    FILE * (*fopen_real) (const char *, const char *) = dlsym(RTLD_NEXT, "fopen");
    char buf[PATH_MAX];
    return fopen_real(rewrite(path, buf), mode);
}

int __xstat(int ver, const char * path, struct stat * st)
{
    int (*__xstat_real) (int ver, const char *, struct stat *) = dlsym(RTLD_NEXT, "__xstat");
    char buf[PATH_MAX];
    return __xstat_real(ver, rewrite(path, buf), st);
}
