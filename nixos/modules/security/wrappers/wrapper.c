#define _GNU_SOURCE
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdnoreturn.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/xattr.h>
#include <fcntl.h>
#include <dirent.h>
#include <errno.h>
#include <linux/capability.h>
#include <sys/prctl.h>
#include <limits.h>
#include <stdint.h>
#include <syscall.h>
#include <byteswap.h>

#ifndef SOURCE_PROG
#error SOURCE_PROG should be defined via preprocessor commandline
#endif

// aborts when false, printing the failed expression
#define ASSERT(expr) ((expr) ? (void) 0 : assert_failure(#expr))
// aborts when returns non-zero, printing the failed expression and errno
#define MUSTSUCCEED(expr) ((expr) ? print_errno_and_die(#expr) : (void) 0)

extern char **environ;

// Wrapper debug variable name
static char *wrapper_debug = "WRAPPER_DEBUG";

#define CAP_SETPCAP 8

#if __BYTE_ORDER == __BIG_ENDIAN
#define LE32_TO_H(x) bswap_32(x)
#else
#define LE32_TO_H(x) (x)
#endif

static noreturn void assert_failure(const char *assertion) {
    fprintf(stderr, "Assertion `%s` in NixOS's wrapper.c failed.\n", assertion);
    fflush(stderr);
    abort();
}

static noreturn void print_errno_and_die(const char *assertion) {
    fprintf(stderr, "Call `%s` in NixOS's wrapper.c failed: %s\n", assertion, strerror(errno));
    fflush(stderr);
    abort();
}

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

int main(int argc, char **argv) {
    ASSERT(argc >= 1);

    // Read the capabilities set on the wrapper and raise them in to
    // the ambient set so the program we're wrapping receives the
    // capabilities too!
    if (make_caps_ambient("/proc/self/exe") != 0) {
        return 1;
    }

    execve(SOURCE_PROG, argv, environ);
    
    fprintf(stderr, "%s: cannot run `%s': %s\n",
        argv[0], SOURCE_PROG, strerror(errno));

    return 1;
}
