#include <stdio.h>
#include <spawn.h>

int main(int argc, char** argv, char** env) {
    if (@available(macOS 26, *)) {
        int ret;
        pid_t pid;
        posix_spawn_file_actions_t actions;
        if ((ret = posix_spawn_file_actions_init(&actions))) {
            printf("cannot create file_actions\n");
        }
        if ((ret = posix_spawn_file_actions_addchdir(&actions, "/tmp"))) {
            printf("cannot add_chdir\n");
        }
        if ((ret = posix_spawnp(&pid, "pwd", &actions, NULL, argv, env))) {
            printf("cannot spawn\n");
        }
    } else {
        printf(":(\n");
    }
}
