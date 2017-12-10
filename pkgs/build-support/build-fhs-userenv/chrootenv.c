#define _GNU_SOURCE

#include <errno.h>
#include <error.h>

#define errorf(status, fmt, ...)                                               \
  error_at_line(status, errno, __FILE__, __LINE__, fmt, ##__VA_ARGS__)

#include <dirent.h>
#include <ftw.h>
#include <sched.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sysexits.h>
#include <unistd.h>

#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/wait.h>

char *env_whitelist[] = {"TERM",
                         "DISPLAY",
                         "XAUTHORITY",
                         "HOME",
                         "XDG_RUNTIME_DIR",
                         "LANG",
                         "SSL_CERT_FILE",
                         "DBUS_SESSION_BUS_ADDRESS"};

char **env_build(char *names[], size_t len) {
  char *env, **ret = malloc((len + 1) * sizeof(char *)), **ptr = ret;

  for (size_t i = 0; i < len; i++) {
    if ((env = getenv(names[i]))) {
      if (asprintf(ptr++, "%s=%s", names[i], env) < 0)
        errorf(EX_OSERR, "asprintf");
    }
  }

  *ptr = NULL;
  return ret;
}

struct bind {
  char *from;
  char *to;
};

struct bind binds[] = {{"/", "host"},   {"/proc", "proc"}, {"/sys", "sys"},
                       {"/nix", "nix"}, {"/tmp", "tmp"},   {"/var", "var"},
                       {"/run", "run"}, {"/dev", "dev"},   {"/home", "home"}};

void bind(struct bind *bind) {
  DIR *src = opendir(bind->from);

  if (src) {
    if (closedir(src) < 0)
      errorf(EX_IOERR, "closedir");

    if (mkdir(bind->to, 0755) < 0)
      errorf(EX_IOERR, "mkdir");

    if (mount(bind->from, bind->to, "bind", MS_BIND | MS_REC, NULL) < 0)
      errorf(EX_OSERR, "mount");

  } else {
    // https://github.com/NixOS/nixpkgs/issues/31104
    if (errno != ENOENT)
      errorf(EX_OSERR, "opendir");
  }
}

void spitf(char *path, char *fmt, ...) {
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

int nftw_rm(const char *path, const struct stat *sb, int type,
            struct FTW *ftw) {
  if (remove(path) < 0)
    errorf(EX_IOERR, "nftw_rm");

  return 0;
}

#define LEN(x) sizeof(x) / sizeof(*x)

int main(int argc, char *argv[]) {
  if (argc < 2) {
    fprintf(stderr, "Usage: %s command [arguments...]\n"
                    "Requires Linux kernel >= 3.19 with CONFIG_USER_NS.\n",
            argv[0]);
    exit(EX_USAGE);
  }

  char tmpl[] = "/tmp/chrootenvXXXXXX";
  char *root = mkdtemp(tmpl);

  if (root == NULL)
    errorf(EX_IOERR, "mkdtemp");

  // Don't make root private so that privilege drops inside chroot are possible:
  if (chmod(root, 0755) < 0)
    errorf(EX_IOERR, "chmod");

  pid_t cpid = fork();

  if (cpid < 0)
    errorf(EX_OSERR, "fork");

  if (cpid == 0) {
    uid_t uid = getuid();
    gid_t gid = getgid();

    // If we are root, no need to create new user namespace.
    if (uid == 0) {
      if (unshare(CLONE_NEWNS) < 0)
        errorf(EX_OSERR, "unshare() failed: You may have an old kernel or have CLONE_NEWUSER disabled by your distribution security settings.");
      // Mark all mounted filesystems as slave so changes
      // don't propagate to the parent mount namespace.
      if (mount(NULL, "/", NULL, MS_REC | MS_SLAVE, NULL) < 0)
        errorf(EX_OSERR, "mount");
    } else {
      // Create new mount and user namespaces. CLONE_NEWUSER
      // requires a program to be non-threaded.
      if (unshare(CLONE_NEWNS | CLONE_NEWUSER) < 0)
        errorf(EX_OSERR, "unshare");

      // Map users and groups to the parent namespace.
      // setgroups is only available since Linux 3.19:
      spitf("/proc/self/setgroups", "deny");

      spitf("/proc/self/uid_map", "%d %d 1", uid, uid);
      spitf("/proc/self/gid_map", "%d %d 1", gid, gid);
    }

    if (chdir(root) < 0)
      errorf(EX_IOERR, "chdir");

    for (size_t i = 0; i < LEN(binds); i++)
      bind(&binds[i]);

    if (chroot(root) < 0)
      errorf(EX_OSERR, "chroot");

    if (chdir("/") < 0)
      errorf(EX_OSERR, "chdir");

    argv++;

    if (execvpe(*argv, argv, env_build(env_whitelist, LEN(env_whitelist))) < 0)
      errorf(EX_OSERR, "execvpe");
  }

  int status;

  if (waitpid(cpid, &status, 0) < 0)
    errorf(EX_OSERR, "waitpid");

  if (nftw(root, nftw_rm, getdtablesize(), FTW_DEPTH | FTW_MOUNT | FTW_PHYS) < 0)
    errorf(EX_IOERR, "nftw");

  if (WIFEXITED(status))
    return WEXITSTATUS(status);
  else if (WIFSIGNALED(status))
    kill(getpid(), WTERMSIG(status));

  return EX_OSERR;
}
