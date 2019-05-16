#include <assert.h>
#include <fcntl.h>
#include <spawn.h>
#include <stdio.h>
#include <unistd.h>

#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>

#define TESTPATH "/foo/bar/test"

extern char **environ;

void test_spawn(void) {
    pid_t pid;
    int ret;
    posix_spawn_file_actions_t file_actions;
    char *argv[] = {"true", NULL};

    assert(posix_spawn_file_actions_init(&file_actions) == 0);

    ret = posix_spawn(&pid, TESTPATH, &file_actions, NULL, argv, environ);

    assert(ret == 0);
    assert(waitpid(pid, NULL, 0) != -1);
}

void test_execv(void) {
    char *argv[] = {"true", NULL};
    assert(execv(TESTPATH, argv) == 0);
}

int main(void)
{
    FILE *testfp;
    int testfd;
    struct stat testsb;

    testfp = fopen(TESTPATH, "r");
    assert(testfp != NULL);
    fclose(testfp);

    testfd = open(TESTPATH, O_RDONLY);
    assert(testfd != -1);
    close(testfd);

    assert(access(TESTPATH, X_OK) == 0);

    assert(stat(TESTPATH, &testsb) != -1);

    test_spawn();
    test_execv();

    /* If all goes well, this is never reached because test_execv() replaces
     * the current process.
     */
    return 0;
}
