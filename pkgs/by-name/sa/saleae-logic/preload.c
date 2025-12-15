/*
 * LD_PRELOAD trick to make Saleae Logic work from a read-only installation
 * directory.
 *
 * Saleae Logic tries to write to a few directories inside its installation
 * directory. Because the Nix store is read-only, we have to redirect access to
 * this file somewhere else. Here's the map:
 *
 *   $out/Settings/    => $HOME/.saleae-logic/Settings/
 *   $out/Databases/   => $HOME/.saleae-logic/Databases/
 *   $out/Errors/      => $HOME/.saleae-logic/Errors/
 *   $out/Calibration/ => $HOME/.saleae-logic/Calibration/
 *
 * This also makes the software multi-user aware :-)
 *
 * NOTE: AFAIK (Bjørn Forsman), Logic version 1.2+ was supposed to have a
 * command line parameter for redirecting these write operations, but
 * apparently that feature got postponed.
 *
 * Usage:
 *   gcc -shared -fPIC -DOUT="$out" preload.c -o preload.so -ldl
 *   LD_PRELOAD=$PWD/preload.so ./result/Logic
 *
 * To see the paths that are modified at runtime, set the environment variable
 * PRELOAD_DEBUG to 1 (or anything really; debugging is on as long as the
 * variable exists).
 */

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <dlfcn.h>
#include <limits.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <errno.h>

#ifndef OUT
#error Missing OUT define - path to the installation directory.
#endif

/*
 * TODO: How to properly wrap "open", which is declared as a variadic function
 * in glibc? The man page lists these signatures:
 *
 *   int open(const char *pathname, int flags);
 *   int open(const char *pathname, int flags, mode_t mode);
 *
 * But using either signature in this code cause a compile error, because
 * glibc has declared the function as "int open(const char *, int, ...)".
 * Same thing with "openat".
 *
 * For now we discard the variadic args. It seems to work.
 *
 * Relevant:
 * http://stackoverflow.com/questions/28462523/how-to-wrap-ioctlint-d-unsigned-long-request-using-ld-preload
 */
typedef FILE *(*fopen_func_t)(const char *path, const char *mode);
typedef FILE *(*fopen64_func_t)(const char *path, const char *mode);
typedef int (*open_func_t)(const char *pathname, int flags, ...);
typedef int (*open64_func_t)(const char *pathname, int flags, ...);
typedef int (*openat_func_t)(int dirfd, const char *pathname, int flags, ...);
typedef int (*openat64_func_t)(int dirfd, const char *pathname, int flags, ...);
typedef int (*xstat_func_t)(int vers, const char *pathname, struct stat *buf);
typedef int (*xstat64_func_t)(int vers, const char *pathname, struct stat64 *buf);
typedef int (*access_func_t)(const char *pathname, int mode);
typedef int (*faccessat_func_t)(int dirfd, const char *pathname, int mode, int flags);
typedef int (*unlink_func_t)(const char *pathname);

/*
 * Redirect $out/{Settings,Databases,Errors,Calibration}/ => $HOME/.saleae-logic/.
 * Path is truncated if bigger than PATH_MAX.
 *
 * @param pathname Original file path.
 * @param buffer Pointer to a buffer of size PATH_MAX bytes that this function
 * will write the new redirected path to (if needed).
 *
 * @return Pointer to the resulting path. It will either be equal to the
 * pathname (no redirect) or buffer argument (was redirected).
 */
static const char *redirect(const char *pathname, char *buffer)
{
	const char *homepath;
	const char *new_path;
	static char have_warned;
	const char *remainder;
	static char have_initialized;
	static size_t out_strlen;
	static size_t settings_strlen;
	static size_t databases_strlen;
	static size_t errors_strlen;
	static size_t calibration_strlen;
	int ret;
	int i;

	homepath = getenv("HOME");
	if (!homepath) {
		homepath = "/";
		if (!have_warned && getenv("PRELOAD_DEBUG")) {
			fprintf(stderr, "preload_debug: WARNING: HOME is unset, using \"/\" (root) instead.\n");
			have_warned = 1;
		}
	}

	if (!have_initialized) {
		/*
		 * The directories that Saleae Logic expects to find.
		 * The first element is intentionally empty (create base dir).
		 */
		char *dirs[] = {"", "/Settings", "/Databases", "/Errors", "/Calibration"};
		char old_settings_path[PATH_MAX];
		access_func_t orig_access;

		out_strlen = strlen(OUT);
		settings_strlen = out_strlen + strlen("/Settings");
		databases_strlen = out_strlen + strlen("/Databases");
		errors_strlen = out_strlen + strlen("/Errors");
		calibration_strlen = out_strlen + strlen("/Calibration");
		for (i = 0; i < sizeof dirs / sizeof dirs[0]; i++) {
			snprintf(buffer, PATH_MAX, "%s/.saleae-logic%s", homepath, dirs[i]);
			buffer[PATH_MAX-1] = '\0';
			ret = mkdir(buffer, 0755);
			if (0 != ret && errno != EEXIST) {
				fprintf(stderr, "ERROR: Failed to create directory \"%s\": %s\n",
						buffer, strerror(errno));
				return NULL;
			}
		}

		/*
		 * Automatic migration of the settings file:
		 * ~/.saleae-logic-settings.xml => ~/.saleae-logic/Settings/settings.xml
		 */
		snprintf(old_settings_path, PATH_MAX, "%s/.saleae-logic-settings.xml", homepath);
		old_settings_path[PATH_MAX-1] = '\0';
		orig_access = (access_func_t)dlsym(RTLD_NEXT, "access");
		if (orig_access(old_settings_path, F_OK) == 0) {
			snprintf(buffer, PATH_MAX, "%s/.saleae-logic/Settings/settings.xml", homepath);
			buffer[PATH_MAX-1] = '\0';
			ret = rename(old_settings_path, buffer);
			if (ret != 0) {
				fprintf(stderr, "WARN: Failed to move %s to %s",
						old_settings_path, buffer);
			}
		}

		have_initialized = 1;
	}

	new_path = pathname;
	remainder = pathname + out_strlen;

	if ((strncmp(OUT "/Settings", pathname, settings_strlen) == 0) ||
	    (strncmp(OUT "/Databases", pathname, databases_strlen) == 0) ||
	    (strncmp(OUT "/Errors", pathname, errors_strlen) == 0) ||
	    (strncmp(OUT "/Calibration", pathname, calibration_strlen) == 0)) {
		snprintf(buffer, PATH_MAX, "%s/.saleae-logic%s", homepath, remainder);
		buffer[PATH_MAX-1] = '\0';
		new_path = buffer;
	}

	return new_path;
}

FILE *fopen(const char *pathname, const char *mode)
{
	const char *path;
	char buffer[PATH_MAX];
	fopen_func_t orig_fopen;

	orig_fopen = (fopen_func_t)dlsym(RTLD_NEXT, "fopen");
	path = redirect(pathname, buffer);
	if (path != pathname && getenv("PRELOAD_DEBUG")) {
		fprintf(stderr, "preload_debug: fopen(\"%s\", \"%s\") => \"%s\"\n", pathname, mode, path);
	}

	return orig_fopen(path, mode);
}

FILE *fopen64(const char *pathname, const char *mode)
{
	const char *path;
	char buffer[PATH_MAX];
	fopen64_func_t orig_fopen64;

	orig_fopen64 = (fopen64_func_t)dlsym(RTLD_NEXT, "fopen64");
	path = redirect(pathname, buffer);
	if (path != pathname && getenv("PRELOAD_DEBUG")) {
		fprintf(stderr, "preload_debug: fopen64(\"%s\", \"%s\") => \"%s\"\n", pathname, mode, path);
	}

	return orig_fopen64(path, mode);
}

int open(const char *pathname, int flags, ...)
{
	const char *path;
	char buffer[PATH_MAX];
	open_func_t orig_open;

	orig_open = (open_func_t)dlsym(RTLD_NEXT, "open");
	path = redirect(pathname, buffer);
	if (path != pathname && getenv("PRELOAD_DEBUG")) {
		fprintf(stderr, "preload_debug: open(\"%s\", ...) => \"%s\"\n", pathname, path);
	}

	return orig_open(path, flags);
}

int open64(const char *pathname, int flags, ...)
{
	const char *path;
	char buffer[PATH_MAX];
	open64_func_t orig_open64;

	orig_open64 = (open64_func_t)dlsym(RTLD_NEXT, "open64");
	path = redirect(pathname, buffer);
	if (path != pathname && getenv("PRELOAD_DEBUG")) {
		fprintf(stderr, "preload_debug: open64(\"%s\", ...) => \"%s\"\n", pathname, path);
	}

	return orig_open64(path, flags);
}

int openat(int dirfd, const char *pathname, int flags, ...)
{
	const char *path;
	char buffer[PATH_MAX];
	openat_func_t orig_openat;

	orig_openat = (openat_func_t)dlsym(RTLD_NEXT, "openat");
	path = redirect(pathname, buffer);
	if (path != pathname && getenv("PRELOAD_DEBUG")) {
		fprintf(stderr, "preload_debug: openat(%d, \"%s\", %#x) => \"%s\"\n", dirfd, pathname, flags, path);
	}

	return orig_openat(dirfd, path, flags);
}

int openat64(int dirfd, const char *pathname, int flags, ...)
{
	const char *path;
	char buffer[PATH_MAX];
	openat64_func_t orig_openat64;

	orig_openat64 = (openat64_func_t)dlsym(RTLD_NEXT, "openat64");
	path = redirect(pathname, buffer);
	if (path != pathname && getenv("PRELOAD_DEBUG")) {
		fprintf(stderr, "preload_debug: openat64(%d, \"%s\", %#x) => \"%s\"\n", dirfd, pathname, flags, path);
	}

	return orig_openat64(dirfd, path, flags);
}

/*
 * Notes about "stat".
 *
 * The stat function is special, at least in glibc, in that it cannot be
 * directly overridden by LD_PRELOAD, due to it being inline wrapper around
 * __xstat. The __xstat functions take one extra parameter, a version number,
 * to indicate what "struct stat" should look like. This trick allows changing
 * the contents of mode_t without changing the shared library major number. See
 * sys/stat.h header for more info.
 */
int __xstat(int vers, const char *pathname, struct stat *buf)
{
	const char *path;
	char buffer[PATH_MAX];
	xstat_func_t orig_xstat;

	orig_xstat = (xstat_func_t)dlsym(RTLD_NEXT, "__xstat");
	path = redirect(pathname, buffer);
	if (path != pathname && getenv("PRELOAD_DEBUG")) {
		fprintf(stderr, "preload_debug: (__x)stat(\"%s\", ...) => \"%s\"\n", pathname, path);
	}

	return orig_xstat(vers, path, buf);
}

int __xstat64(int vers, const char *pathname, struct stat64 *buf)
{
	const char *path;
	char buffer[PATH_MAX];
	xstat64_func_t orig_xstat64;

	orig_xstat64 = (xstat64_func_t)dlsym(RTLD_NEXT, "__xstat64");
	path = redirect(pathname, buffer);
	if (path != pathname && getenv("PRELOAD_DEBUG")) {
		fprintf(stderr, "preload_debug: (__x)stat64(\"%s\", ...) => \"%s\"\n", pathname, path);
	}

	return orig_xstat64(vers, path, buf);
}

int access(const char *pathname, int mode)
{
	const char *path;
	char buffer[PATH_MAX];
	access_func_t orig_access;

	orig_access = (access_func_t)dlsym(RTLD_NEXT, "access");
	path = redirect(pathname, buffer);
	if (path != pathname && getenv("PRELOAD_DEBUG")) {
		fprintf(stderr, "preload_debug: access(\"%s\", ...) => \"%s\"\n", pathname, path);
	}

	return orig_access(path, mode);
}

int faccessat(int dirfd, const char *pathname, int mode, int flags)
{
	const char *path;
	char buffer[PATH_MAX];
	faccessat_func_t orig_faccessat;

	orig_faccessat = (faccessat_func_t)dlsym(RTLD_NEXT, "faccessat");
	path = redirect(pathname, buffer);
	if (path != pathname && getenv("PRELOAD_DEBUG")) {
		fprintf(stderr, "preload_debug: faccessat(\"%s\", ...) => \"%s\"\n", pathname, path);
	}

	return orig_faccessat(dirfd, path, mode, flags);
}

int unlink(const char *pathname)
{
	const char *path;
	char buffer[PATH_MAX];
	unlink_func_t orig_unlink;

	orig_unlink = (unlink_func_t)dlsym(RTLD_NEXT, "unlink");
	path = redirect(pathname, buffer);
	if (path != pathname && getenv("PRELOAD_DEBUG")) {
		fprintf(stderr, "preload_debug: unlink(\"%s\") => \"%s\"\n", pathname, path);
	}

	return orig_unlink(path);
}
