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
#include <elf.h>


extern char **environ;

// Wrapper debug variable name
static char *wrapper_debug = "WRAPPER_DEBUG";

#define LOG_PREFIX "nixos-setuid-wrapper: "

#define CAP_SETPCAP 8

#if __BYTE_ORDER == __BIG_ENDIAN
#define LE32_TO_H(x) bswap_32(x)
#else
#define LE32_TO_H(x) (x)
#endif

#if ELF_HEADER_SIZE == 32
typedef Elf32_Ehdr Ehdr;
#elif ELF_HEADER_SIZE == 64
typedef Elf64_Ehdr Ehdr;
#else
#error unsupported ELF_HEADER_SIZE
#endif

int get_last_cap(unsigned *last_cap) {
    FILE* file = fopen("/proc/sys/kernel/cap_last_cap", "r");
    if (file == NULL) {
        int saved_errno = errno;
        perror(LOG_PREFIX "failed to open /proc/sys/kernel/cap_last_cap\n");
        return -saved_errno;
    }
    int res = fscanf(file, "%u", last_cap);
    if (res == EOF) {
        int saved_errno = errno;
        perror(LOG_PREFIX "could not read number from /proc/sys/kernel/cap_last_cap: %s\n");
        return -saved_errno;
    }
    fclose(file);
    return 0;
}

// Given the path to this program, fetch its configured capability set
// (as set by `setcap ... /path/to/file`) and raise those capabilities
// into the Ambient set.
static int make_caps_ambient(int exe_fd) {
    struct vfs_ns_cap_data data = {};

    int r = fgetxattr(exe_fd, "security.capability", &data, sizeof(data));

    if (r < 0) {
        if (errno == ENODATA) {
            // no capabilities set
            return 0;
        }
        fprintf(stderr, LOG_PREFIX "cannot get capabilities for wrapper: %s", strerror(errno));
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
            fprintf(stderr, LOG_PREFIX "BUG! Unsupported capability version 0x%x on wrapper. Report to NixOS bugtracker\n", version);
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
        fprintf(stderr, LOG_PREFIX "failed to inherit capabilities: %s", strerror(errno));
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
                fprintf(stderr, LOG_PREFIX "cap_setpcap in set, skipping it\n");
            }
            continue;
        }
        if (prctl(PR_CAP_AMBIENT, PR_CAP_AMBIENT_RAISE, (unsigned long) cap, 0, 0)) {
            fprintf(stderr, LOG_PREFIX "cannot raise the capability %d into the ambient set: %s\n", cap, strerror(errno));
            return 1;
        }
        if (getenv(wrapper_debug)) {
            fprintf(stderr, LOG_PREFIX "raised %d into the ambient capability set\n", cap);
        }
    }

    return 0;
}

ssize_t get_file_size(int exe_fd) {
  struct stat s;

  if (fstat(exe_fd, &s) == -1) {
    fprintf(stderr, LOG_PREFIX "failed to stat file /proc/self/exe: %s\n", strerror(errno));
    return -1;
  }

  return s.st_size;
}

int pread_all(int fd, void* buf, size_t size, off_t offset) {
    for (;;) {
        ssize_t nread = pread(fd, buf, size, offset);
        if (nread > 0) {
            if (nread != size) {
              fprintf(stderr, LOG_PREFIX "short read on /proc/self/exe: expected: %zu, got: %zd\n", size, nread);
              return -1;
            }
            return 0;
        }
        if (errno != EINTR) {
            perror(LOG_PREFIX "failed to read /proc/self/exe");
            return -1;
        }
    }
}

ssize_t get_elf_size(int exe_fd) {
  Ehdr elf_header;
  if (pread_all(exe_fd, &elf_header, sizeof(Ehdr), 0) == -1) {
      return -1;
  };

  return elf_header.e_shoff + (elf_header.e_shnum * elf_header.e_shentsize);
}

// Reads the program name from the end of the ELF structure. We assume that the
// program name was appended to the program using `echo -n`.
char* get_progname(int exe_fd) {
    ssize_t file_size = get_file_size(exe_fd);
    if (file_size < 0) {
        return NULL;
    }

    ssize_t elf_size = get_elf_size(exe_fd);
    if (elf_size < 0) {
        return NULL;
    }

    if (elf_size > file_size) {
        fprintf(stderr, LOG_PREFIX "ELF size of /proc/self/exe is larger than file size!?\n");
        return NULL;
    }

    if (elf_size == file_size) {
        fprintf(stderr, LOG_PREFIX "no extra bytes found for target program name found in security wrapper, did you forget to concat it?\n");
        return NULL;
    }

    char *prog_name = calloc(file_size - elf_size, 1);
    if (!prog_name) {
        perror(LOG_PREFIX "cannot allocate memory for prog_name");
        return NULL;
    }

    if (pread_all(exe_fd, prog_name, file_size - elf_size, elf_size) == -1) {
        free(prog_name);
        return NULL;
    };

    return prog_name;
}

int main(int argc, char **argv) {
    int exe_fd = open("/proc/self/exe", O_CLOEXEC);
    if (exe_fd < 0) {
        perror(LOG_PREFIX "cannot open /proc/self/exe");
        return 1;
    }

    char *prog_name = get_progname(exe_fd);
    if (!prog_name) {
        return 1;
    }

    // Read the capabilities set on the wrapper and raise them in to
    // the ambient set so the program we're wrapping receives the
    // capabilities too!
    if (make_caps_ambient(exe_fd) != 0) {
        free(prog_name);
        return 1;
    }

    execve(prog_name, argv, environ);

    fprintf(stderr, LOG_PREFIX "cannot execute `%s': %s\n", prog_name, strerror(errno));
    free(prog_name);

    return 1;
}
