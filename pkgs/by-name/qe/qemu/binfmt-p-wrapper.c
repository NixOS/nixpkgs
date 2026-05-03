// This is a tiny wrapper that converts the extra arv[0] argument
// from binfmt-misc with the P flag enabled to QEMU parameters.
// It also prevents LD_* environment variables from being applied
// to QEMU itself.

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#ifndef TARGET_QEMU
#error "Define TARGET_QEMU to be the path to the qemu-user binary (e.g., -DTARGET_QEMU=\"/full/path/to/qemu-riscv64\")"
#endif

extern char **environ;

int main(int argc, char *argv[]) {
    if (argc < 3) {
        fprintf(stderr, "%s: This should be run as the binfmt interpreter with the P flag\n", argv[0]);
        fprintf(stderr, "%s: My preconfigured qemu-user binary: %s\n", argv[0], TARGET_QEMU);
        return 1;
    }

    size_t environ_count = 0;
    for (char **cur = environ; *cur != NULL; ++cur) {
        environ_count++;
    }

    size_t new_argc = 3;
    size_t new_argv_alloc = argc + 2 * environ_count + 2; // [ "-E", env ] for each LD_* env + [ "-0", argv0 ]
    char **new_argv = (char**)malloc((new_argv_alloc + 1) * sizeof(char*));
    if (!new_argv) {
        fprintf(stderr, "FATAL: Failed to allocate new argv array\n");
        abort();
    }

    new_argv[0] = TARGET_QEMU;
    new_argv[1] = "-0";
    new_argv[2] = argv[2];

    // Pass all LD_ env variables as -E and strip them in `new_environ`
    size_t new_environc = 0;
    char **new_environ = (char**)malloc((environ_count + 1) * sizeof(char*));
    if (!new_environ) {
        fprintf(stderr, "FATAL: Failed to allocate new environ array\n");
        abort();
    }

    for (char **cur = environ; *cur != NULL; ++cur) {
        if (strncmp("LD_", *cur, 3) == 0) {
            new_argv[new_argc++] = "-E";
            new_argv[new_argc++] = *cur;
        } else {
            new_environ[new_environc++] = *cur;
        }
    }
    new_environ[new_environc] = NULL;

    size_t new_arg_start = new_argc;
    new_argc += argc - 3 + 2; // [ "--", full_binary_path ]

    if (argc > 3) {
        memcpy(&new_argv[new_arg_start + 2], &argv[3], (argc - 3) * sizeof(char**));
    }

    new_argv[new_arg_start] = "--";
    new_argv[new_arg_start + 1] = argv[1];
    new_argv[new_argc] = NULL;

#ifdef DEBUG
    for (size_t i = 0; i < new_argc; ++i) {
        fprintf(stderr, "argv[%zu] = %s\n", i, new_argv[i]);
    }
#endif

    return execve(new_argv[0], new_argv, new_environ);
}

// vim: et:ts=4:sw=4
