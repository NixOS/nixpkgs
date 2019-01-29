#define _GNU_SOURCE

#include <glib.h>
#include <glib/gstdio.h>

#include <errno.h>
#include <sched.h>
#include <unistd.h>

#define fail(s, err) g_error("%s: %s: %s", __func__, s, g_strerror(err))
#define fail_if(expr)                                                          \
  if (expr)                                                                    \
    fail(#expr, errno);

#include <ftw.h>

#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>

const gchar *bind_blacklist[] = {"bin", "etc", "host", "usr", "lib", "lib64", "lib32", "sbin", NULL};

void bind_mount(const gchar *source, const gchar *target) {
  fail_if(g_mkdir(target, 0755));
  fail_if(mount(source, target, "bind", MS_BIND | MS_REC, NULL));
}

void bind_mount_host(const gchar *host, const gchar *guest) {
  g_autofree gchar *point = g_build_filename(guest, "host", NULL);
  bind_mount(host, point);
}

void bind_mount_item(const gchar *host, const gchar *guest, const gchar *name) {
  g_autofree gchar *source = g_build_filename(host, name, NULL);
  g_autofree gchar *target = g_build_filename(guest, name, NULL);

  if (G_LIKELY(g_file_test(source, G_FILE_TEST_IS_DIR)))
    bind_mount(source, target);
}

void bind(const gchar *host, const gchar *guest) {
  g_autoptr(GError) err = NULL;
  g_autoptr(GDir) dir = g_dir_open(host, 0, &err);

  if (err != NULL)
    fail("g_dir_open", errno);

  const gchar *item;

  while (item = g_dir_read_name(dir))
    if (!g_strv_contains(bind_blacklist, item))
      bind_mount_item(host, guest, item);

  bind_mount_host(host, guest);
}

void spit(const char *path, char *fmt, ...) {
  va_list args;
  va_start(args, fmt);

  FILE *f = g_fopen(path, "w");

  if (f == NULL)
    fail("g_fopen", errno);

  g_vfprintf(f, fmt, args);
  fclose(f);
}

int nftw_remove(const char *path, const struct stat *sb, int type,
                struct FTW *ftw) {
  return remove(path);
}

int main(gint argc, gchar **argv) {
  const gchar *self = *argv++;

  if (argc < 2) {
    g_message("%s command [arguments...]", self);
    return 1;
  }

  if (g_getenv("NIX_CHROOTENV"))
    g_warning("chrootenv doesn't stack!");
  else
    g_setenv("NIX_CHROOTENV", "", TRUE);

  g_autofree gchar *prefix =
      g_build_filename(g_get_tmp_dir(), "chrootenvXXXXXX", NULL);

  fail_if(!g_mkdtemp_full(prefix, 0755));

  pid_t cpid = fork();

  if (cpid < 0)
    fail("fork", errno);

  else if (cpid == 0) {
    uid_t uid = getuid();
    gid_t gid = getgid();

    if (unshare(CLONE_NEWNS | CLONE_NEWUSER) < 0) {
      int unshare_errno = errno;

      g_message("Requires Linux version >= 3.19 built with CONFIG_USER_NS");
      if (g_file_test("/proc/sys/kernel/unprivileged_userns_clone",
                      G_FILE_TEST_EXISTS))
        g_message("Run: sudo sysctl -w kernel.unprivileged_userns_clone=1");

      fail("unshare", unshare_errno);
    }

    spit("/proc/self/setgroups", "deny");
    spit("/proc/self/uid_map", "%d %d 1", uid, uid);
    spit("/proc/self/gid_map", "%d %d 1", gid, gid);

    bind("/", prefix);

    fail_if(chroot(prefix));
    fail_if(chdir("/"));
    fail_if(execvp(*argv, argv));
  }

  else {
    int status;

    fail_if(waitpid(cpid, &status, 0) != cpid);
    fail_if(nftw(prefix, nftw_remove, getdtablesize(),
                 FTW_DEPTH | FTW_MOUNT | FTW_PHYS));

    if (WIFEXITED(status))
      return WEXITSTATUS(status);

    else if (WIFSIGNALED(status))
      kill(getpid(), WTERMSIG(status));

    return 1;
  }
}
