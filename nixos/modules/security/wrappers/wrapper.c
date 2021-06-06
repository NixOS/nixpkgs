#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/xattr.h>
#include <fcntl.h>
#include <dirent.h>
#include <assert.h>
#include <errno.h>
#include <linux/capability.h>
#include <sys/prctl.h>
#include <limits.h>
#include <stdint.h>
#include <syscall.h>
#include <byteswap.h>

// Make sure assertions are not compiled out, we use them to codify
// invariants about this program and we want it to fail fast and
// loudly if they are violated.
#undef NDEBUG

extern char **environ;

// The WRAPPER_DIR macro is supplied at compile time so that it cannot
// be changed at runtime
static char *wrapper_dir = WRAPPER_DIR;

// Wrapper debug variable name
static char *wrapper_debug = "WRAPPER_DEBUG";

#define CAP_SETPCAP 8

#if __BYTE_ORDER == __BIG_ENDIAN
#define LE32_TO_H(x) bswap_32(x)
#else
#define LE32_TO_H(x) (x)
#endif

int get_last_cap(unsigned *last_cap) {
    FILE* file = fopen("/proc/sys/kernel/cap_last_cap", "r");
    if (file == NULL) {
        int saved_errno = errno;
        fprintf(stderr, "failed to open /proc/sys/kernel/cap_last_cap: %s\n", strerror(errno));
        return -saved_errno;
    }
    int res = fscanf(file, "%u", last_cap);
    if (res == EOF) {
        int saved_errno = errno;
        fprintf(stderr, "could not read number from /proc/sys/kernel/cap_last_cap: %s\n", strerror(errno));
        return -saved_errno;
    }
    fclose(file);
    return 0;
}

// Given the path to this program, fetch its configured capability set
// (as set by `setcap ... /path/to/file`) and raise those capabilities
// into the Ambient set.
static int make_caps_ambient(const char *self_path) {
    struct vfs_ns_cap_data data = {};
    int r = getxattr(self_path, "security.capability", &data, sizeof(data));

    if (r < 0) {
        if (errno == ENODATA) {
            // no capabilities set
            return 0;
        }
        fprintf(stderr, "cannot get capabilities for %s: %s", self_path, strerror(errno));
        return 1;
    }

    size_t size;
    uint32_t version = LE32_TO_H(data.magic_etc) & VFS_CAP_REVISION_MASK;
    switch (version) {
        case VFS_CAP_REVISION_1:
            size = VFS_CAP_U32_1;
            break;
        case VFS_CAP_REVISION_2:
        case VFS_CAP_REVISION_3:
            size = VFS_CAP_U32_3;
            break;
        default:
            fprintf(stderr, "BUG! Unsupported capability version 0x%x on %s. Report to NixOS bugtracker\n", version, self_path);
            return 1;
    }

    const struct __user_cap_header_struct header = {
      .version = _LINUX_CAPABILITY_VERSION_3,
      .pid = getpid(),
    };
    struct __user_cap_data_struct user_data[2] = {};

    for (size_t i = 0; i < size; i++) {
        // merge inheritable & permitted into one
        user_data[i].permitted = user_data[i].inheritable =
            LE32_TO_H(data.data[i].inheritable) | LE32_TO_H(data.data[i].permitted);
    }

    if (syscall(SYS_capset, &header, &user_data) < 0) {
        fprintf(stderr, "failed to inherit capabilities: %s", strerror(errno));
        return 1;
    }
    unsigned last_cap;
    r = get_last_cap(&last_cap);
    if (r < 0) {
        return 1;
    }
    uint64_t set = user_data[0].permitted | (uint64_t)user_data[1].permitted << 32;
    for (unsigned cap = 0; cap < last_cap; cap++) {
        if (!(set & (1ULL << cap))) {
            continue;
        }

        // Check for the cap_setpcap capability, we set this on the
        // wrapper so it can elevate the capabilities to the Ambient
        // set but we do not want to propagate it down into the
        // wrapped program.
        //
        // TODO: what happens if that's the behavior you want
        // though???? I'm preferring a strict vs. loose policy here.
        if (cap == CAP_SETPCAP) {
            if(getenv(wrapper_debug)) {
                fprintf(stderr, "cap_setpcap in set, skipping it\n");
            }
            continue;
        }
        if (prctl(PR_CAP_AMBIENT, PR_CAP_AMBIENT_RAISE, (unsigned long) cap, 0, 0)) {
            fprintf(stderr, "cannot raise the capability %d into the ambient set: %s\n", cap, strerror(errno));
            return 1;
        }
        if (getenv(wrapper_debug)) {
            fprintf(stderr, "raised %d into the ambient capability set\n", cap);
        }
    }

    return 0;
}

int readlink_malloc(const char *p, char **ret) {
    size_t l = FILENAME_MAX+1;
    int r;

    for (;;) {
        char *c = calloc(l, sizeof(char));
        if (!c) {
            return -ENOMEM;
        }

        ssize_t n = readlink(p, c, l-1);
        if (n < 0) {
            r = -errno;
            free(c);
            return r;
        }

        if ((size_t) n < l-1) {
            c[n] = 0;
            *ret = c;
            return 0;
        }

        free(c);
        l *= 2;
    }
}

int main(int argc, char **argv) {
    char *self_path = NULL;
    int self_path_size = readlink_malloc("/proc/self/exe", &self_path);
    if (self_path_size < 0) {
        fprintf(stderr, "cannot readlink /proc/self/exe: %s", strerror(-self_path_size));
    }

    // Make sure that we are being executed from the right location,
    // i.e., `safe_wrapper_dir'.  This is to prevent someone from creating
    // hard link `X' from some other location, along with a false
    // `X.real' file, to allow arbitrary programs from being executed
    // with elevated capabilities.
    int len = strlen(wrapper_dir);
    if (len > 0 && '/' == wrapper_dir[len - 1])
      --len;
    assert(!strncmp(self_path, wrapper_dir, len));
    assert('/' == wrapper_dir[0]);
    assert('/' == self_path[len]);

    // Make *really* *really* sure that we were executed as
    // `self_path', and not, say, as some other setuid program. That
    // is, our effective uid/gid should match the uid/gid of
    // `self_path'.
    struct stat st;
    assert(lstat(self_path, &st) != -1);

    assert(!(st.st_mode & S_ISUID) || (st.st_uid == geteuid()));
    assert(!(st.st_mode & S_ISGID) || (st.st_gid == getegid()));

    // And, of course, we shouldn't be writable.
    assert(!(st.st_mode & (S_IWGRP | S_IWOTH)));

    // Read the path of the real (wrapped) program from <self>.real.
    char real_fn[PATH_MAX + 10];
    int real_fn_size = snprintf(real_fn, sizeof(real_fn), "%s.real", self_path);
    assert(real_fn_size < sizeof(real_fn));

    int fd_self = open(real_fn, O_RDONLY);
    assert(fd_self != -1);

    char source_prog[PATH_MAX];
    len = read(fd_self, source_prog, PATH_MAX);
    assert(len != -1);
    assert(len < sizeof(source_prog));
    assert(len > 0);
    source_prog[len] = 0;

    close(fd_self);

    // Read the capabilities set on the wrapper and raise them in to
    // the ambient set so the program we're wrapping receives the
    // capabilities too!
    if (make_caps_ambient(self_path) != 0) {
        free(self_path);
        return 1;
    }
    free(self_path);

    execve(source_prog, argv, environ);
    
    fprintf(stderr, "%s: cannot run `%s': %s\n",
        argv[0], source_prog, strerror(errno));

    return 1;
}
