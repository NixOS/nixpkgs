#define _GNU_SOURCE
#include <assert.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <limits.h>

#include <sys/types.h>

static const char* _getenv_or_abort(const char* envvar_name) {
    const char* out = getenv(envvar_name);
    if (!out) {
        fprintf(stderr, "Environment variable '%s' was not found.\n", envvar_name);
        abort();
    }
    return out;
}

static void test_readlink_proc_self_exe(void) {
    const char* exp_exe_path = _getenv_or_abort("NIX_TEST_EXP_SELF_EXE");
    const int exp_exe_path_len = strlen(exp_exe_path);
    const ssize_t exp_ret = exp_exe_path_len;

    char act_link_path[PATH_MAX];
    memset(act_link_path, 0, sizeof(act_link_path));

    const ssize_t ret = readlink("/proc/self/exe", act_link_path, PATH_MAX);

    assert(ret == exp_ret);
    assert(strncmp(act_link_path, exp_exe_path, exp_exe_path_len) == 0);
}

static void test_readlink_other_link_exist(void) {
    const char* exp_exe_path = _getenv_or_abort("PWD");
    const int exp_exe_path_len = strlen(exp_exe_path);
    const ssize_t exp_ret = exp_exe_path_len;

    char act_link_path[PATH_MAX];
    memset(act_link_path, 0, sizeof(act_link_path));

    const ssize_t ret = readlink("/proc/self/cwd", act_link_path, PATH_MAX);

    assert(ret == exp_ret);
    assert(strncmp(act_link_path, exp_exe_path, exp_exe_path_len) == 0);
}

static void test_readlink_other_file_does_not_exist(void) {
    const char* exp_exe_path = "";
    const int exp_exe_path_len = strlen(exp_exe_path);
    const ssize_t exp_ret = -1;

    char act_link_path[PATH_MAX];
    memset(act_link_path, 0, sizeof(act_link_path));

    const ssize_t ret = readlink("/proc/self/does-not-exists", act_link_path, PATH_MAX);

    assert(ret == exp_ret);
    assert(strncmp(act_link_path, exp_exe_path, exp_exe_path_len) == 0);
}

static void test_readlink_other_file_not_a_link(void) {
    const char* exp_exe_path = "";
    const int exp_exe_path_len = strlen(exp_exe_path);
    const ssize_t exp_ret = -1;

    char act_link_path[PATH_MAX];
    memset(act_link_path, 0, sizeof(act_link_path));

    const ssize_t ret = readlink("/proc/self/status", act_link_path, PATH_MAX);

    assert(ret == exp_ret);
    assert(strncmp(act_link_path, exp_exe_path, exp_exe_path_len) == 0);
}

int main(int argc, char *argv[])
{
    test_readlink_proc_self_exe();
    test_readlink_other_link_exist();
    test_readlink_other_file_does_not_exist();
    test_readlink_other_file_not_a_link();
}
