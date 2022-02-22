#define _GNU_SOURCE
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <unistd.h>
#include <dlfcn.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/param.h>
#include <fcntl.h>
#include <limits.h>
#include <string.h>
#include <spawn.h>
#include <dirent.h>

#define MAX_REDIRECTS 128

#ifdef __APPLE__
  struct dyld_interpose {
    const void * replacement;
    const void * replacee;
  };
  #define WRAPPER(ret, name) static ret _libredirect_self_wrapper_##name
  #define LOOKUP_REAL(name) &name
  #define WRAPPER_DEF(name) \
    __attribute__((used)) static struct dyld_interpose _libredirect_self_interpose_##name \
      __attribute__((section("__DATA,__interpose"))) = { &_libredirect_self_wrapper_##name, &name };
#else
  #define WRAPPER(ret, name) ret name
  #define LOOKUP_REAL(name) dlsym(RTLD_NEXT, #name)
  #define WRAPPER_DEF(name)
#endif

static int nrRedirects = 0;
static char * from[MAX_REDIRECTS];
static char * to[MAX_REDIRECTS];

static int isInitialized = 0;

// FIXME: might run too late.
static void init() __attribute__((constructor));

static void init()
{
    if (isInitialized) return;

    char * spec = getenv("NIX_SELF_REDIRECTS");
    if (!spec) return;

    // Ensure we only run this code once.
    // We do not do `unsetenv("NIX_SELF_REDIRECTS")` to ensure that redirects
    // also get initialized for subprocesses.
    isInitialized = 1;

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

static size_t rewrite_to_out_arg(
    const char * path_buf, size_t path_bufsize, char * buf, size_t bufsize)
{
    const int redirect_count = (path_buf == NULL) ? 0 : nrRedirects;
    int cp_len;

    for (int n = 0; n < redirect_count; ++n) {
        const size_t len = strlen(from[n]);
        if (strncmp(path_buf, from[n], MIN(path_bufsize, len)) != 0) continue;

        cp_len = snprintf(buf, bufsize, "%s%s", to[n], path_buf + len);
        if (0 > cp_len) abort();
        return cp_len;
    }

    cp_len = snprintf(buf, MIN(path_bufsize, bufsize), "%s", path_buf);
    if (0 > cp_len) abort();
    return cp_len;
}

WRAPPER(ssize_t, readlink)(const char * path, char * buf, size_t bufsize)
{
    int (*readlink_real) (const char *, char *, size_t) = LOOKUP_REAL(readlink);

    const char* self_exe_symlink_path = "/proc/self/exe";
    int len = strlen(self_exe_symlink_path);
    // TODO: What would it be on OSX?
    if (strncmp(path, self_exe_symlink_path, len) != 0)
    {
        // Nothing special to do, simply forward to real.
        return readlink_real(path, buf, bufsize);
    }

    char temp_buf[PATH_MAX];
    ssize_t result = readlink_real(path, temp_buf, PATH_MAX);
    if (result < 0) {
        return result;
    }
    return rewrite_to_out_arg(temp_buf, PATH_MAX, buf, bufsize);
}
WRAPPER_DEF(readlink)

// TODO: Should we handle this as well?
// ssize_t readlinkat(int dirfd, const char *path, char *buf, size_t bufsiz); /* flags=AT_SYMLINK_NOFOLLOW */
