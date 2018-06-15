/* Google Talk Plugin executes a helper program in /opt.  This
   LD_PRELOAD library intercepts execvp() calls to redirect them to
   the corresponding location in $out. */

#define _GNU_SOURCE
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <limits.h>

char origDir [] = "/opt/google/talkplugin";
char realDir [] = OUT "/libexec/google/talkplugin";

const char * rewrite(const char * path, char * buf)
{
    if (strncmp(path, origDir, sizeof(origDir) - 1) != 0) return path;
    if (snprintf(buf, PATH_MAX, "%s%s", realDir, path + sizeof(origDir) - 1) >= PATH_MAX)
        abort();
    return buf;
}

int execvp(const char * path, char * const argv[])
{
    int (*_execvp) (const char *, char * const argv[]) = dlsym(RTLD_NEXT, "execvp");
    char buf[PATH_MAX];
    return _execvp(rewrite(path, buf), argv);
}

int open(const char *path, int flags, ...)
{
    char buf[PATH_MAX];
    int (*_open) (const char *, int, mode_t) = dlsym(RTLD_NEXT, "open");
    mode_t mode = 0;
    if (flags & O_CREAT) {
        va_list ap;
        va_start(ap, flags);
        mode = va_arg(ap, mode_t);
        va_end(ap);
    }
    return _open(rewrite(path, buf), flags, mode);
}

int open64(const char *path, int flags, ...)
{
    char buf[PATH_MAX];
    int (*_open64) (const char *, int, mode_t) = dlsym(RTLD_NEXT, "open64");
    mode_t mode = 0;
    if (flags & O_CREAT) {
        va_list ap;
        va_start(ap, flags);
        mode = va_arg(ap, mode_t);
        va_end(ap);
    }
    return _open64(rewrite(path, buf), flags, mode);
}
