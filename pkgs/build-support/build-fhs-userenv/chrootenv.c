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

#define LEN(x) sizeof(x) / sizeof(*x)

char *env_blacklist[] = {};

char **env_filter(char *envp[]) {
  char **filtered_envp = malloc(sizeof(*envp));
  size_t n = 0;

  while (*envp != NULL) {
    bool blacklisted = false;

    for (size_t i = 0; i < LEN(env_blacklist); i++) {
      if (!strncmp(*envp, env_blacklist[i], strlen(env_blacklist[i]))) {
        blacklisted = true;
        break;
      }
    }

    if (!blacklisted) {
      filtered_envp = realloc(filtered_envp, (n + 2) * sizeof(*envp));

      if (filtered_envp == NULL)
        errorf(EX_OSERR, "realloc");

      filtered_envp[n++] = *envp;
    }

    envp++;
  }

  filtered_envp[n] = NULL;
  return filtered_envp;
}

void bind(char *from, char *to) {
  if (mkdir(to, 0755) < 0)
    errorf(EX_IOERR, "mkdir");

  if (mount(from, to, "bind", MS_BIND | MS_REC, NULL) < 0)
    errorf(EX_OSERR, "mount");
}

char *strjoin(char *dir, char *name) {
  char *path = malloc(strlen(dir) + strlen(name) + 1);

  if (path == NULL)
    errorf(EX_OSERR, "malloc");

  if (strcpy(path, dir) < 0)
    errorf(EX_IOERR, "strcpy");

  if (strcat(path, name) < 0)
    errorf(EX_IOERR, "strcat");

  return path;
}

char *bind_blacklist[] = {".", "..", "bin", "etc", "host", "usr"};

bool bind_blacklisted(char *name) {
  for (size_t i = 0; i < LEN(bind_blacklist); i++) {
    if (!strcmp(bind_blacklist[i], name))
      return true;
  }

  return false;
}

bool isdir(char *path) {
  struct stat buf;
  stat(path, &buf);
  return S_ISDIR(buf.st_mode);
}

void bind_to_cwd(char *prefix) {
  DIR *prefix_dir = opendir(prefix);

  if (prefix_dir == NULL)
    errorf(EX_OSERR, "opendir");

  struct dirent *prefix_dirent;

  while (prefix_dirent = readdir(prefix_dir)) {
    if (bind_blacklisted(prefix_dirent->d_name))
      continue;

    char *prefix_dirent_path = strjoin(prefix, prefix_dirent->d_name);

    if (isdir(prefix_dirent_path)) {
      bind(prefix_dirent_path, prefix_dirent->d_name);
    } else {
      char *host_target = strjoin("host/", prefix_dirent->d_name);

      if (symlink(host_target, prefix_dirent->d_name) < 0)
        errorf(EX_IOERR, "symlink");

      free(host_target);
    }

    free(prefix_dirent_path);
  }

  bind(prefix, "host");

  if (closedir(prefix_dir) < 0)
    errorf(EX_IOERR, "closedir");
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

#define REQUIREMENTS "Linux version >= 3.19 built with CONFIG_USER_NS option"

int main(int argc, char *argv[], char *envp[]) {
  if (argc < 2) {
    fprintf(stderr, "Usage: %s command [arguments...]\n"
                    "Requires " REQUIREMENTS ".\n",
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
        errorf(EX_OSERR, "unshare: requires " REQUIREMENTS);
      // Mark all mounted filesystems as slave so changes
      // don't propagate to the parent mount namespace.
      if (mount(NULL, "/", NULL, MS_REC | MS_SLAVE, NULL) < 0)
        errorf(EX_OSERR, "mount");
    } else {
      // Create new mount and user namespaces. CLONE_NEWUSER
      // requires a program to be non-threaded.
      if (unshare(CLONE_NEWNS | CLONE_NEWUSER) < 0) {
        if (access("/tmp/proc/sys/kernel/unprivileged_userns_clone", F_OK) < 0)
          errorf(EX_OSERR, "unshare: requires " REQUIREMENTS);
        else
          errorf(EX_OSERR, "unshare: run `sudo sysctl -w "
                           "kernel.unprivileged_userns_clone=1`");
      }

      // Map users and groups to the parent namespace.
      // setgroups is only available since Linux 3.19:
      spitf("/proc/self/setgroups", "deny");

      spitf("/proc/self/uid_map", "%d %d 1", uid, uid);
      spitf("/proc/self/gid_map", "%d %d 1", gid, gid);
    }

    if (chdir(root) < 0)
      errorf(EX_IOERR, "chdir");

    bind_to_cwd("/");

    if (chroot(root) < 0)
      errorf(EX_OSERR, "chroot");

    if (chdir("/") < 0)
      errorf(EX_OSERR, "chdir");

    argv++;

    if (execvpe(*argv, argv, env_filter(envp)) < 0)
      errorf(EX_OSERR, "execvpe");
  }

  int status;

  if (waitpid(cpid, &status, 0) < 0)
    errorf(EX_OSERR, "waitpid");

  if (nftw(root, nftw_rm, getdtablesize(), FTW_DEPTH | FTW_MOUNT | FTW_PHYS) <
      0)
    errorf(EX_IOERR, "nftw");

  if (WIFEXITED(status))
    return WEXITSTATUS(status);
  else if (WIFSIGNALED(status))
    kill(getpid(), WTERMSIG(status));

  return EX_OSERR;
}
