/* Spotify looks for its theme data in /usr/share/spotify/theme.  This
   LD_PRELOAD library intercepts open() and stat() calls to redirect
   them to the corresponding location in $out. */

#define _GNU_SOURCE
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <limits.h>

char themeDir [] = "/usr/share/spotify/theme";
char realThemeDir [] = OUT "/share/spotify/theme";

const char * rewrite(const char * path, char * buf)
{
    if (strncmp(path, themeDir, sizeof(themeDir) - 1) != 0) return path;
    if (snprintf(buf, PATH_MAX, "%s%s", realThemeDir, path + sizeof(themeDir) - 1) >= PATH_MAX)
        abort();
    return buf;
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

int __xstat64(int ver, const char *path, struct stat64 *st)
{
    char buf[PATH_MAX];
    int (*___xstat64) (int ver, const char *, struct stat64 *) = dlsym(RTLD_NEXT, "__xstat64");
    return ___xstat64(ver, rewrite(path, buf), st);
}

int access(const char *path, int mode)
{
    char buf[PATH_MAX];
    int (*_access) (const char *path, int mode) = dlsym(RTLD_NEXT, "access");
    return _access(rewrite(path, buf), mode);
}
