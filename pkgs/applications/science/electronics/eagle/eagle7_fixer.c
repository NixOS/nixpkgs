/*
 * LD_PRELOAD trick to make Eagle (schematic editor and PCB layout tool from
 * CadSoft) work from a read-only installation directory.
 *
 * When Eagle starts, it looks for the license file in <eagle>/bin/eagle.key
 * (where <eagle> is the install path). If eagle.key is not found, Eagle checks
 * for write access to <eagle>/bin/, shows a license dialog to the user and
 * then attempts to write a license file to <eagle>/bin/.
 *
 * This will of course fail when Eagle is installed in the read-only Nix store.
 * Hence this library that redirects accesses to the those paths in the
 * following way:
 *
 *   <eagle>/bin              => $HOME
 *   <eagle>/bin/eagle.key    => $HOME/.eagle.key
 *
 * Also, if copying an example project to ~/eagle/ (in the Eagle GUI), Eagle
 * chmod's the destination with read-only permission bits (presumably because
 * the source is read-only) and fails to complete the copy operation.
 * Therefore, the mode argument in calls to chmod() is OR'ed with the S_IWUSR
 * bit (write by owner).
 *
 * Usage:
 *   gcc -shared -fPIC -DEAGLE_PATH="$out/eagle-${version}" eagle_fixer.c -o eagle_fixer.so -ldl
 *   LD_PRELOAD=$PWD/eagle_fixer.so ./result/bin/eagle
 *
 * To see the paths that are modified at runtime, set the environment variable
 * EAGLE_FIXER_DEBUG to 1.
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

#ifndef EAGLE_PATH
#error Missing EAGLE_PATH, path to the eagle-${version} installation directory.
#endif

typedef FILE *(*fopen_func_t)(const char *path, const char *mode);
typedef int (*access_func_t)(const char *pathname, int mode);
typedef int (*chmod_func_t)(const char *path, mode_t mode);

/*
 * Map <eagle>/bin to $HOME and <eagle>/bin/eagle.key to $HOME/.eagle.key
 *
 * Path is truncated if bigger than PATH_MAX. It's not threadsafe, but that's
 * OK.
 */
static const char *redirect(const char *pathname)
{
	static char buffer[PATH_MAX];
	const char *homepath;
	const char *new_path;
	static int have_warned;

	homepath = getenv("HOME");
	if (!homepath) {
		homepath = "/";
		if (!have_warned && getenv("EAGLE_FIXER_DEBUG")) {
			fprintf(stderr, "eagle_fixer: HOME is unset, using \"/\" (root) instead.\n");
			have_warned = 1;
		}
	}

	new_path = pathname;
	if (strcmp(EAGLE_PATH "/bin", pathname) == 0) {
		/* redirect to $HOME */
		new_path = homepath;
	} else if (strcmp(EAGLE_PATH "/bin/eagle.key", pathname) == 0) {
		/* redirect to $HOME/.eagle.key */
		snprintf(buffer, PATH_MAX, "%s/.eagle.key", homepath);
		buffer[PATH_MAX-1] = '\0';
		new_path = buffer;
	}

	return new_path;
}

FILE *fopen(const char *pathname, const char *mode)
{
	FILE *fp;
	const char *path;
	fopen_func_t orig_fopen;

	orig_fopen = (fopen_func_t)dlsym(RTLD_NEXT, "fopen");
	path = redirect(pathname);
	fp = orig_fopen(path, mode);

	if (path != pathname && getenv("EAGLE_FIXER_DEBUG")) {
		fprintf(stderr, "eagle_fixer: fopen(\"%s\", \"%s\") => \"%s\": fp=%p\n", pathname, mode, path, fp);
	}

	return fp;
}

int access(const char *pathname, int mode)
{
	int ret;
	const char *path;
	access_func_t orig_access;

	orig_access = (access_func_t)dlsym(RTLD_NEXT, "access");
	path = redirect(pathname);
	ret = orig_access(path, mode);

	if (path != pathname && getenv("EAGLE_FIXER_DEBUG")) {
		fprintf(stderr, "eagle_fixer: access(\"%s\", %d) => \"%s\": ret=%d\n", pathname, mode, path, ret);
	}

	return ret;
}

int chmod(const char *pathname, mode_t mode)
{
	int ret;
	mode_t new_mode;
	chmod_func_t orig_chmod;

	orig_chmod = (chmod_func_t)dlsym(RTLD_NEXT, "chmod");
	new_mode = mode | S_IWUSR;
	ret = orig_chmod(pathname, new_mode);

	if (getenv("EAGLE_FIXER_DEBUG")) {
		fprintf(stderr, "eagle_fixer: chmod(\"%s\", %o) => %o: ret=%d\n", pathname, mode, new_mode, ret);
	}

	return ret;
}
