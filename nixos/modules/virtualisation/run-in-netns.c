#define _GNU_SOURCE

#include <stdio.h>
#include <string.h>
#include <errno.h>

#include <unistd.h>
#include <sched.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mount.h>
#include <fcntl.h>
#include <linux/limits.h>

int main(int argc, char * * argv)
{
    if (argc < 3) {
        fprintf(stderr, "%s: missing arguments\n", argv[0]);
        return 1;
    }

    char nsPath[PATH_MAX];

    sprintf(nsPath, "/run/netns/%s", argv[1]);

    int fd = open(nsPath, O_RDONLY);
    if (fd == -1) {
        fprintf(stderr, "%s: opening network namespace: %s\n", argv[0], strerror(errno));
        return 1;
    }

    if (setns(fd, CLONE_NEWNET) == -1) {
        fprintf(stderr, "%s: setting network namespace: %s\n", argv[0], strerror(errno));
        return 1;
    }

    umount2(nsPath, MNT_DETACH);
    if (unlink(nsPath) == -1) {
        fprintf(stderr, "%s: unlinking network namespace: %s\n", argv[0], strerror(errno));
        return 1;
    }

    /* FIXME: Remount /sys so that /sys/class/net reflects the
       interfaces visible in the network namespace. This requires
       bind-mounting /sys/fs/cgroups etc. */

    execv(argv[2], argv + 2);
    fprintf(stderr, "%s: running command: %s\n", argv[0], strerror(errno));
    return 1;
}
