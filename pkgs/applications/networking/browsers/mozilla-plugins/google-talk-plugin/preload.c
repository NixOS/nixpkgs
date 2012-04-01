/* Google Talk Plugin executes a helper program in /opt.  This
   LD_PRELOAD library intercepts execvp() calls to redirect them to
   the corresponding location in $out. */

#define _GNU_SOURCE
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <limits.h>

char origDir [] = "/opt/google/talkplugin/GoogleTalkPlugin";
char realDir [] = OUT "/libexec/google/talkplugin/GoogleTalkPlugin";

const char * rewrite(const char * path, char * buf)
{
    if (strncmp(path, origDir, sizeof(origDir) - 1) != 0) return path;
    if (snprintf(buf, PATH_MAX, "%s%s", realDir, path + sizeof(origDir) - 1) >= PATH_MAX)
        abort();
    return buf;
}

int execvp(const char * path, char * const argv[])
{
    fprintf(stderr, "foo %s\n", path);
    int (*_execvp) (const char *, char * const argv[]) = dlsym(RTLD_NEXT, "execvp");
    char buf[PATH_MAX];
    return _execvp(rewrite(path, buf), argv);
}
