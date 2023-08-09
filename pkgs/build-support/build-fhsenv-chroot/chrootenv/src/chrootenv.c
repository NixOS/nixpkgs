#define _GNU_SOURCE

#include <glib.h>
#include <glib/gstdio.h>

#include <errno.h>
#include <sched.h>
#include <unistd.h>

#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/syscall.h>

#define fail(s, err) g_error("%s: %s: %s", __func__, s, g_strerror(err))
#define fail_if(expr)                                                          \
  if (expr)                                                                    \
    fail(#expr, errno);

const gchar *bind_blacklist[] = {"bin", "etc", "host", "real-host", "usr", "lib", "lib64", "lib32", "sbin", "opt", NULL};

int pivot_root(const char *new_root, const char *put_old) {
  return syscall(SYS_pivot_root, new_root, put_old);
}

void mount_tmpfs(const gchar *target) {
  fail_if(mount("none", target, "tmpfs", 0, NULL));
}

void bind_mount(const gchar *source, const gchar *target) {
  fail_if(g_mkdir(target, 0755));
  fail_if(mount(source, target, NULL, MS_BIND | MS_REC, NULL));
}

const gchar *create_tmpdir() {
  gchar *prefix =
      g_build_filename(g_get_tmp_dir(), "chrootenvXXXXXX", NULL);
  fail_if(!g_mkdtemp_full(prefix, 0755));
  return prefix;
}

void pivot_host(const gchar *guest) {
  g_autofree gchar *point = g_build_filename(guest, "host", NULL);
  fail_if(g_mkdir(point, 0755));
  fail_if(pivot_root(guest, point));
}

void bind_mount_item(const gchar *host, const gchar *guest, const gchar *name) {
  g_autofree gchar *source = g_build_filename(host, name, NULL);
  g_autofree gchar *target = g_build_filename(guest, name, NULL);

  if (G_LIKELY(g_file_test(source, G_FILE_TEST_IS_DIR)))
    bind_mount(source, target);
}

void bind(const gchar *host, const gchar *guest) {
  mount_tmpfs(guest);

  pivot_host(guest);

  g_autofree gchar *host_dir = g_build_filename("/host", host, NULL);

  g_autoptr(GError) err = NULL;
  g_autoptr(GDir) dir = g_dir_open(host_dir, 0, &err);

  if (err != NULL)
    fail("g_dir_open", errno);

  const gchar *item;

  while ((item = g_dir_read_name(dir)))
    if (!g_strv_contains(bind_blacklist, item))
      bind_mount_item(host_dir, "/", item);
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

int main(gint argc, gchar **argv) {
  const gchar *self = *argv++;

  if (argc < 2) {
    g_message("%s command [arguments...]", self);
    return 1;
  }

  g_autofree const gchar *prefix = create_tmpdir();

  pid_t cpid = fork();

  if (cpid < 0)
    fail("fork", errno);

  else if (cpid == 0) {
    uid_t uid = getuid();
    gid_t gid = getgid();

    int namespaces = CLONE_NEWNS;
    if (uid != 0) {
      namespaces |= CLONE_NEWUSER;
    }
    if (unshare(namespaces) < 0) {
      int unshare_errno = errno;

      g_message("Requires Linux version >= 3.19 built with CONFIG_USER_NS");
      if (g_file_test("/proc/sys/kernel/unprivileged_userns_clone",
                      G_FILE_TEST_EXISTS))
        g_message("Run: sudo sysctl -w kernel.unprivileged_userns_clone=1");

      fail("unshare", unshare_errno);
    }

    // hide all mounts we do from the parent
    fail_if(mount(0, "/", 0, MS_SLAVE | MS_REC, 0));

    if (uid != 0) {
      spit("/proc/self/setgroups", "deny");
      spit("/proc/self/uid_map", "%d %d 1", uid, uid);
      spit("/proc/self/gid_map", "%d %d 1", gid, gid);
    }

    // If there is a /host directory, assume this is nested chrootenv and use it as host instead.
    gboolean nested_host = g_file_test("/host", G_FILE_TEST_EXISTS | G_FILE_TEST_IS_DIR);
    g_autofree const gchar *host = nested_host ? "/host" : "/";

    bind(host, prefix);

    // Replace /host by an actual (inner) /host.
    if (nested_host) {
      fail_if(g_mkdir("/real-host", 0755));
      fail_if(mount("/host/host", "/real-host", NULL, MS_BIND | MS_REC, NULL));
      // For some reason umount("/host") returns EBUSY even immediately after
      // pivot_root. We detach it at least to keep `/proc/mounts` from blowing
      // up in nested cases.
      fail_if(umount2("/host", MNT_DETACH));
      fail_if(mount("/real-host", "/host", NULL, MS_MOVE, NULL));
      fail_if(rmdir("/real-host"));
    }

    fail_if(chdir("/"));
    fail_if(execvp(*argv, argv));
  }

  else {
    int status;

    fail_if(waitpid(cpid, &status, 0) != cpid);
    fail_if(rmdir(prefix));

    if (WIFEXITED(status))
      return WEXITSTATUS(status);

    else if (WIFSIGNALED(status))
      kill(getpid(), WTERMSIG(status));

    return 1;
  }
}
