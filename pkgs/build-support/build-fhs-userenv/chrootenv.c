#define _GNU_SOURCE

#include <errno.h>
#include <error.h>

#define errorf(status, fmt, ...)                                               \
  error_at_line(status, errno, __FILE__, __LINE__, fmt, ##__VA_ARGS__)

#include <dirent.h>
#include <ftw.h>
#include <sched.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sysexits.h>
#include <unistd.h>

#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/wait.h>

#define LEN(x) (sizeof(x) / sizeof(*x))

// TODO: fill together with @abbradar when he gets better
const char *environ_blacklist[] = {};

void environ_blacklist_filter() {
  for (size_t i = 0; i < LEN(environ_blacklist); i++) {
    if (unsetenv(environ_blacklist[i]) < 0)
      errorf(EX_OSERR, "unsetenv(%s)", environ_blacklist[i]);
  }
}

void bind(const char *from, const char *to) {
  if (mkdir(to, 0755) < 0)
    errorf(EX_IOERR, "mkdir(%s)", to);

  if (mount(from, to, "bind", MS_BIND | MS_REC, NULL) < 0)
    errorf(EX_OSERR, "mount(%s, %s)", from, to);
}

const char *bind_blacklist[] = {".", "..", "bin", "etc", "host", "usr"};

bool str_contains(const char *needle, const char **haystack, size_t len) {
  for (size_t i = 0; i < len; i++) {
    if (!strcmp(needle, haystack[i]))
      return true;
  }

  return false;
}

bool is_dir(const char *path) {
  struct stat buf;

  if (stat(path, &buf) < 0)
    errorf(EX_IOERR, "stat(%s)", path);

  return S_ISDIR(buf.st_mode);
}

void bind_to_cwd(const char *prefix) {
  DIR *prefix_dir = opendir(prefix);

  if (prefix_dir == NULL)
    errorf(EX_IOERR, "opendir(%s)", prefix);

  struct dirent *prefix_dirent;

  while (prefix_dirent = readdir(prefix_dir)) {
    if (str_contains(prefix_dirent->d_name, bind_blacklist,
                     LEN(bind_blacklist)))
      continue;

    char *prefix_dirent_path;

    if (asprintf(&prefix_dirent_path, "%s%s", prefix, prefix_dirent->d_name) <
        0)
      errorf(EX_IOERR, "asprintf");

    if (is_dir(prefix_dirent_path)) {
      bind(prefix_dirent_path, prefix_dirent->d_name);
    } else {
      char *host_target;

      if (asprintf(&host_target, "host/%s", prefix_dirent->d_name) < 0)
        errorf(EX_IOERR, "asprintf");

      if (symlink(host_target, prefix_dirent->d_name) < 0)
        errorf(EX_IOERR, "symlink(%s, %s)", host_target, prefix_dirent->d_name);

      free(host_target);
    }

    free(prefix_dirent_path);
  }

  bind(prefix, "host");

  if (closedir(prefix_dir) < 0)
    errorf(EX_IOERR, "closedir(%s)", prefix);
}

void spitf(const char *path, char *fmt, ...) {
  va_list args;
  va_start(args, fmt);

  FILE *f = fopen(path, "w");

  if (f == NULL)
    errorf(EX_IOERR, "spitf(%s): fopen", path);

  if (vfprintf(f, fmt, args) < 0)
    errorf(EX_IOERR, "spitf(%s): vfprintf", path);

  if (fclose(f) < 0)
    errorf(EX_IOERR, "spitf(%s): fclose", path);
}

int nftw_remove(const char *path, const struct stat *sb, int type,
                struct FTW *ftw) {
  return remove(path);
}

#define REQUIREMENTS                                                           \
  "Requires Linux version >= 3.19 built with CONFIG_USER_NS option.\n"

int main(int argc, char *argv[]) {
  const char *self = *argv++;

  if (argc < 2) {
    fprintf(stderr, "Usage: %s command [arguments...]\n" REQUIREMENTS, self);
    exit(EX_USAGE);
  }

  if (getenv("NIX_CHROOTENV") != NULL) {
    fputs("Can't create chrootenv inside chrootenv!\n", stderr);
    exit(EX_USAGE);
  }

  if (setenv("NIX_CHROOTENV", "1", false) < 0)
    errorf(EX_OSERR, "setenv(NIX_CHROOTENV, 1)");

  const char *temp = getenv("TMPDIR");

  if (temp == NULL)
    temp = "/tmp";

  char *root;

  if (asprintf(&root, "%s/chrootenvXXXXXX", temp) < 0)
    errorf(EX_IOERR, "asprintf");

  root = mkdtemp(root);

  if (root == NULL)
    errorf(EX_IOERR, "mkdtemp(%s)", root);

  // Don't make root private so that privilege drops inside chroot are possible:
  if (chmod(root, 0755) < 0)
    errorf(EX_IOERR, "chmod(%s, 0755)", root);

  pid_t cpid = fork();

  if (cpid < 0)
    errorf(EX_OSERR, "fork");

  if (cpid == 0) {
    uid_t uid = getuid();
    gid_t gid = getgid();

    // If we are root, no need to create new user namespace.
    if (uid == 0) {
      if (unshare(CLONE_NEWNS) < 0) {
        fputs(REQUIREMENTS, stderr);
        errorf(EX_OSERR, "unshare");
      }
      // Mark all mounted filesystems as slave so changes
      // don't propagate to the parent mount namespace.
      if (mount(NULL, "/", NULL, MS_REC | MS_SLAVE, NULL) < 0)
        errorf(EX_OSERR, "mount");
    } else {
      // Create new mount and user namespaces. CLONE_NEWUSER
      // requires a program to be non-threaded.
      if (unshare(CLONE_NEWNS | CLONE_NEWUSER) < 0) {
        fputs(access("/proc/sys/kernel/unprivileged_userns_clone", F_OK)
                  ? REQUIREMENTS
                  : "Run: sudo sysctl -w kernel.unprivileged_userns_clone=1\n",
              stderr);
        errorf(EX_OSERR, "unshare");
      }

      // Map users and groups to the parent namespace.
      // setgroups is only available since Linux 3.19:
      spitf("/proc/self/setgroups", "deny");

      spitf("/proc/self/uid_map", "%d %d 1", uid, uid);
      spitf("/proc/self/gid_map", "%d %d 1", gid, gid);
    }

    if (chdir(root) < 0)
      errorf(EX_IOERR, "chdir(%s)", root);

    bind_to_cwd("/");

    if (chroot(root) < 0)
      errorf(EX_OSERR, "chroot(%s)", root);

    if (chdir("/") < 0)
      errorf(EX_IOERR, "chdir(/)");

    environ_blacklist_filter();

    if (execvp(*argv, argv) < 0)
      errorf(EX_OSERR, "execvp(%s)", *argv);
  }

  int status;

  if (waitpid(cpid, &status, 0) < 0)
    errorf(EX_OSERR, "waitpid(%d)", cpid);

  if (nftw(root, nftw_remove, getdtablesize(),
           FTW_DEPTH | FTW_MOUNT | FTW_PHYS) < 0)
    errorf(EX_IOERR, "nftw(%s)", root);

  free(root);

  if (WIFEXITED(status)) {
    return WEXITSTATUS(status);
  } else if (WIFSIGNALED(status)) {
    kill(getpid(), WTERMSIG(status));
  }

  return EX_OSERR;
}
