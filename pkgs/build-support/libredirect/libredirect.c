#define _GNU_SOURCE
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <unistd.h>
#include <dlfcn.h>
#include <sys/types.h>
#include <sys/stat.h>
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
  #define WRAPPER(ret, name) static ret _libredirect_wrapper_##name
  #define LOOKUP_REAL(name) &name
  #define WRAPPER_DEF(name) \
    __attribute__((used)) static struct dyld_interpose _libredirect_interpose_##name \
      __attribute__((section("__DATA,__interpose"))) = { &_libredirect_wrapper_##name, &name };
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

    char * spec = getenv("NIX_REDIRECTS");
    if (!spec) return;

    // Ensure we only run this code once.
    // We do not do `unsetenv("NIX_REDIRECTS")` to ensure that redirects
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

static const char * rewrite(const char * path, char * buf)
{
    if (path == NULL) return path;
    for (int n = 0; n < nrRedirects; ++n) {
        int len = strlen(from[n]);
        if (strncmp(path, from[n], len) != 0) continue;
        if (snprintf(buf, PATH_MAX, "%s%s", to[n], path + len) >= PATH_MAX)
            abort();
        return buf;
    }

    return path;
}

static char * rewrite_non_const(char * path, char * buf)
{
    // as long as the argument `path` is non-const, we can consider discarding
    // the const qualifier of the return value to be safe.
    return (char *)rewrite(path, buf);
}

static int open_needs_mode(int flags)
{
#ifdef O_TMPFILE
    return (flags & O_CREAT) || (flags & O_TMPFILE) == O_TMPFILE;
#else
    return flags & O_CREAT;
#endif
}

/* The following set of Glibc library functions is very incomplete -
   it contains only what we needed for programs in Nixpkgs. Just add
   more functions as needed. */

WRAPPER(int, open)(const char * path, int flags, ...)
{
    int (*open_real) (const char *, int, mode_t) = LOOKUP_REAL(open);
    mode_t mode = 0;
    if (open_needs_mode(flags)) {
        va_list ap;
        va_start(ap, flags);
        mode = va_arg(ap, mode_t);
        va_end(ap);
    }
    char buf[PATH_MAX];
    return open_real(rewrite(path, buf), flags, mode);
}
WRAPPER_DEF(open)

// In musl libc, open64 is simply a macro for open
#if !defined(__APPLE__) && !defined(open64)
WRAPPER(int, open64)(const char * path, int flags, ...)
{
    int (*open64_real) (const char *, int, mode_t) = LOOKUP_REAL(open64);
    mode_t mode = 0;
    if (open_needs_mode(flags)) {
        va_list ap;
        va_start(ap, flags);
        mode = va_arg(ap, mode_t);
        va_end(ap);
    }
    char buf[PATH_MAX];
    return open64_real(rewrite(path, buf), flags, mode);
}
WRAPPER_DEF(open64)
#endif

WRAPPER(int, openat)(int dirfd, const char * path, int flags, ...)
{
    int (*openat_real) (int, const char *, int, mode_t) = LOOKUP_REAL(openat);
    mode_t mode = 0;
    if (open_needs_mode(flags)) {
        va_list ap;
        va_start(ap, flags);
        mode = va_arg(ap, mode_t);
        va_end(ap);
    }
    char buf[PATH_MAX];
    return openat_real(dirfd, rewrite(path, buf), flags, mode);
}
WRAPPER_DEF(openat)

WRAPPER(FILE *, fopen)(const char * path, const char * mode)
{
    FILE * (*fopen_real) (const char *, const char *) = LOOKUP_REAL(fopen);
    char buf[PATH_MAX];
    return fopen_real(rewrite(path, buf), mode);
}
WRAPPER_DEF(fopen)

#ifdef __GLIBC__
WRAPPER(FILE *, __nss_files_fopen)(const char * path)
{
    FILE * (*__nss_files_fopen_real) (const char *) = LOOKUP_REAL(__nss_files_fopen);
    char buf[PATH_MAX];
    return __nss_files_fopen_real(rewrite(path, buf));
}
WRAPPER_DEF(__nss_files_fopen)
#endif

// In musl libc, fopen64 is simply a macro for fopen
#if !defined(__APPLE__) && !defined(fopen64)
WRAPPER(FILE *, fopen64)(const char * path, const char * mode)
{
    FILE * (*fopen64_real) (const char *, const char *) = LOOKUP_REAL(fopen64);
    char buf[PATH_MAX];
    return fopen64_real(rewrite(path, buf), mode);
}
WRAPPER_DEF(fopen64)
#endif

#ifdef __linux__
WRAPPER(int, __xstat)(int ver, const char * path, struct stat * st)
{
    int (*__xstat_real) (int ver, const char *, struct stat *) = LOOKUP_REAL(__xstat);
    char buf[PATH_MAX];
    return __xstat_real(ver, rewrite(path, buf), st);
}
WRAPPER_DEF(__xstat)
#endif

#ifdef __linux__
WRAPPER(int, __xstat64)(int ver, const char * path, struct stat64 * st)
{
    int (*__xstat64_real) (int ver, const char *, struct stat64 *) = LOOKUP_REAL(__xstat64);
    char buf[PATH_MAX];
    return __xstat64_real(ver, rewrite(path, buf), st);
}
WRAPPER_DEF(__xstat64)
#endif

#if defined(__linux__) && defined(STATX_TYPE)
WRAPPER(int, statx)(int dirfd, const char * restrict pathname, int flags,
    unsigned int mask, struct statx * restrict statxbuf)
{
    int (*statx_real) (int, const char * restrict, int,
        unsigned int, struct statx * restrict) = LOOKUP_REAL(statx);
    char buf[PATH_MAX];
    return statx_real(dirfd, rewrite(pathname, buf), flags, mask, statxbuf);
}
WRAPPER_DEF(statx)
#endif

WRAPPER(int, fstatat)(int dirfd, const char * pathname, struct stat * statbuf, int flags)
{
    int (*fstatat_real) (int, const char *, struct stat *, int) = LOOKUP_REAL(fstatat);
    char buf[PATH_MAX];
    return fstatat_real(dirfd, rewrite(pathname, buf), statbuf, flags);
}
WRAPPER_DEF(fstatat);

// In musl libc, fstatat64 is simply a macro for fstatat
#if !defined(__APPLE__) && !defined(fstatat64)
WRAPPER(int, fstatat64)(int dirfd, const char * pathname, struct stat64 * statbuf, int flags)
{
    int (*fstatat64_real) (int, const char *, struct stat64 *, int) = LOOKUP_REAL(fstatat64);
    char buf[PATH_MAX];
    return fstatat64_real(dirfd, rewrite(pathname, buf), statbuf, flags);
}
WRAPPER_DEF(fstatat64);
#endif

WRAPPER(int, stat)(const char * path, struct stat * st)
{
    int (*__stat_real) (const char *, struct stat *) = LOOKUP_REAL(stat);
    char buf[PATH_MAX];
    return __stat_real(rewrite(path, buf), st);
}
WRAPPER_DEF(stat)

// In musl libc, stat64 is simply a macro for stat
#if !defined(__APPLE__) && !defined(stat64)
WRAPPER(int, stat64)(const char * path, struct stat64 * st)
{
    int (*stat64_real) (const char *, struct stat64 *) = LOOKUP_REAL(stat64);
    char buf[PATH_MAX];
    return stat64_real(rewrite(path, buf), st);
}
WRAPPER_DEF(stat64)
#endif

WRAPPER(int, access)(const char * path, int mode)
{
    int (*access_real) (const char *, int mode) = LOOKUP_REAL(access);
    char buf[PATH_MAX];
    return access_real(rewrite(path, buf), mode);
}
WRAPPER_DEF(access)

WRAPPER(int, posix_spawn)(pid_t * pid, const char * path,
    const posix_spawn_file_actions_t * file_actions,
    const posix_spawnattr_t * attrp,
    char * const argv[], char * const envp[])
{
    int (*posix_spawn_real) (pid_t *, const char *,
        const posix_spawn_file_actions_t *,
        const posix_spawnattr_t *,
        char * const argv[], char * const envp[]) = LOOKUP_REAL(posix_spawn);
    char buf[PATH_MAX];
    return posix_spawn_real(pid, rewrite(path, buf), file_actions, attrp, argv, envp);
}
WRAPPER_DEF(posix_spawn)

WRAPPER(int, posix_spawnp)(pid_t * pid, const char * file,
    const posix_spawn_file_actions_t * file_actions,
    const posix_spawnattr_t * attrp,
    char * const argv[], char * const envp[])
{
    int (*posix_spawnp_real) (pid_t *, const char *,
        const posix_spawn_file_actions_t *,
        const posix_spawnattr_t *,
        char * const argv[], char * const envp[]) = LOOKUP_REAL(posix_spawnp);
    char buf[PATH_MAX];
    return posix_spawnp_real(pid, rewrite(file, buf), file_actions, attrp, argv, envp);
}
WRAPPER_DEF(posix_spawnp)

WRAPPER(int, execv)(const char * path, char * const argv[])
{
    int (*execv_real) (const char * path, char * const argv[]) = LOOKUP_REAL(execv);
    char buf[PATH_MAX];
    return execv_real(rewrite(path, buf), argv);
}
WRAPPER_DEF(execv)

WRAPPER(int, execvp)(const char * path, char * const argv[])
{
    int (*_execvp) (const char *, char * const argv[]) = LOOKUP_REAL(execvp);
    char buf[PATH_MAX];
    return _execvp(rewrite(path, buf), argv);
}
WRAPPER_DEF(execvp)

WRAPPER(int, execve)(const char * path, char * const argv[], char * const envp[])
{
    int (*_execve) (const char *, char * const argv[], char * const envp[]) = LOOKUP_REAL(execve);
    char buf[PATH_MAX];
    return _execve(rewrite(path, buf), argv, envp);
}
WRAPPER_DEF(execve)

WRAPPER(DIR *, opendir)(const char * path)
{
    char buf[PATH_MAX];
    DIR * (*_opendir) (const char*) = LOOKUP_REAL(opendir);

    return _opendir(rewrite(path, buf));
}
WRAPPER_DEF(opendir)

#define SYSTEM_CMD_MAX 512

static char * replace_substring(char * source, char * buf, char * replace_string, char * start_ptr, char * suffix_ptr) {
    char head[SYSTEM_CMD_MAX] = {0};
    strncpy(head, source, start_ptr - source);

    char tail[SYSTEM_CMD_MAX] = {0};
    if(suffix_ptr < source + strlen(source)) {
       strcpy(tail, suffix_ptr);
    }

    sprintf(buf, "%s%s%s", head, replace_string, tail);
    return buf;
}

static char * replace_string(char * buf, char * from, char * to) {
    int num_matches = 0;
    char * matches[SYSTEM_CMD_MAX];
    int from_len = strlen(from);
    for(int i=0; i<strlen(buf); i++){
       char *cmp_start = buf + i;
       if(strncmp(from, cmp_start, from_len) == 0){
          matches[num_matches] = cmp_start;
          num_matches++;
       }
    }
    int len_diff = strlen(to) - strlen(from);
    for(int n = 0; n < num_matches; n++) {
       char replaced[SYSTEM_CMD_MAX];
       replace_substring(buf, replaced, to, matches[n], matches[n]+from_len);
       strcpy(buf, replaced);
       for(int nn = n+1; nn < num_matches; nn++) {
          matches[nn] += len_diff;
       }
    }
    return buf;
}

static void rewriteSystemCall(const char * command, char * buf) {
    char * p = buf;

    #ifdef __APPLE__
    // The dyld environment variable is not inherited by the subprocess spawned
    // by system(), so this hack redefines it.
    Dl_info info;
    dladdr(&rewriteSystemCall, &info);
    p = stpcpy(p, "export DYLD_INSERT_LIBRARIES=");
    p = stpcpy(p, info.dli_fname);
    p = stpcpy(p, ";");
    #endif

    stpcpy(p, command);

    for (int n = 0; n < nrRedirects; ++n) {
       replace_string(buf, from[n], to[n]);
    }
}

WRAPPER(int, system)(const char *command)
{
    int (*_system) (const char*) = LOOKUP_REAL(system);

    char newCommand[SYSTEM_CMD_MAX];
    rewriteSystemCall(command, newCommand);
    return _system(newCommand);
}
WRAPPER_DEF(system)

WRAPPER(int, chdir)(const char *path)
{
    int (*chdir_real) (const char *) = LOOKUP_REAL(chdir);
    char buf[PATH_MAX];
    return chdir_real(rewrite(path, buf));
}
WRAPPER_DEF(chdir);

WRAPPER(int, mkdir)(const char *path, mode_t mode)
{
    int (*mkdir_real) (const char *path, mode_t mode) = LOOKUP_REAL(mkdir);
    char buf[PATH_MAX];
    return mkdir_real(rewrite(path, buf), mode);
}
WRAPPER_DEF(mkdir)

WRAPPER(int, mkdirat)(int dirfd, const char *path, mode_t mode)
{
    int (*mkdirat_real) (int dirfd, const char *path, mode_t mode) = LOOKUP_REAL(mkdirat);
    char buf[PATH_MAX];
    return mkdirat_real(dirfd, rewrite(path, buf), mode);
}
WRAPPER_DEF(mkdirat)

WRAPPER(int, unlink)(const char *path)
{
    int (*unlink_real) (const char *path) = LOOKUP_REAL(unlink);
    char buf[PATH_MAX];
    return unlink_real(rewrite(path, buf));
}
WRAPPER_DEF(unlink)

WRAPPER(int, unlinkat)(int dirfd, const char *path, int flags)
{
    int (*unlinkat_real) (int dirfd, const char *path, int flags) = LOOKUP_REAL(unlinkat);
    char buf[PATH_MAX];
    return unlinkat_real(dirfd, rewrite(path, buf), flags);
}
WRAPPER_DEF(unlinkat)

WRAPPER(int, rmdir)(const char *path)
{
    int (*rmdir_real) (const char *path) = LOOKUP_REAL(rmdir);
    char buf[PATH_MAX];
    return rmdir_real(rewrite(path, buf));
}
WRAPPER_DEF(rmdir)

static void copy_temp_wildcard(char * dest, char * src, int suffixlen) {
    int dest_len = strnlen(dest, PATH_MAX);
    int src_len = strnlen(src, PATH_MAX);
    memcpy(dest + dest_len - (6 + suffixlen), src + src_len - (6 + suffixlen), 6);
}

WRAPPER(int, mkstemp)(char *template)
{
    int (*mkstemp_real) (char *template) = LOOKUP_REAL(mkstemp);
    char buf[PATH_MAX];
    char * rewritten = rewrite_non_const(template, buf);
    int retval = mkstemp_real(rewritten);
    if (retval >= 0 && rewritten != template) {
        copy_temp_wildcard(template, rewritten, 0);
    }
    return retval;
}
WRAPPER_DEF(mkstemp)

WRAPPER(int, mkostemp)(char *template, int flags)
{
    int (*mkostemp_real) (char *template, int flags) = LOOKUP_REAL(mkostemp);
    char buf[PATH_MAX];
    char * rewritten = rewrite_non_const(template, buf);
    int retval = mkostemp_real(rewritten, flags);
    if (retval >= 0 && rewritten != template) {
        copy_temp_wildcard(template, rewritten, 0);
    }
    return retval;
}
WRAPPER_DEF(mkostemp)

WRAPPER(int, mkstemps)(char *template, int suffixlen)
{
    int (*mkstemps_real) (char *template, int suffixlen) = LOOKUP_REAL(mkstemps);
    char buf[PATH_MAX];
    char * rewritten = rewrite_non_const(template, buf);
    int retval = mkstemps_real(rewritten, suffixlen);
    if (retval >= 0 && rewritten != template) {
        copy_temp_wildcard(template, rewritten, suffixlen);
    }
    return retval;
}
WRAPPER_DEF(mkstemps)

WRAPPER(int, mkostemps)(char *template, int suffixlen, int flags)
{
    int (*mkostemps_real) (char *template, int suffixlen, int flags) = LOOKUP_REAL(mkostemps);
    char buf[PATH_MAX];
    char * rewritten = rewrite_non_const(template, buf);
    int retval = mkostemps_real(rewritten, suffixlen, flags);
    if (retval >= 0 && rewritten != template) {
        copy_temp_wildcard(template, rewritten, suffixlen);
    }
    return retval;
}
WRAPPER_DEF(mkostemps)

WRAPPER(char *, mkdtemp)(char *template)
{
    char * (*mkdtemp_real) (char *template) = LOOKUP_REAL(mkdtemp);
    char buf[PATH_MAX];
    char * rewritten = rewrite_non_const(template, buf);
    char * retval = mkdtemp_real(rewritten);
    if (retval == NULL) {
        return retval;
    };
    if (rewritten != template) {
        copy_temp_wildcard(template, rewritten, 0);
    }
    return template;
}
WRAPPER_DEF(mkdtemp)

WRAPPER(char *, mktemp)(char *template)
{
    char * (*mktemp_real) (char *template) = LOOKUP_REAL(mktemp);
    char buf[PATH_MAX];
    char * rewritten = rewrite_non_const(template, buf);
    char * retval = mktemp_real(rewritten);
    if (retval == NULL) {
        return retval;
    };
    if (rewritten != template) {
        copy_temp_wildcard(template, rewritten, 0);
    }
    return template;
}
WRAPPER_DEF(mktemp)
