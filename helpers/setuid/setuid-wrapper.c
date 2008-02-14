#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <dirent.h>

extern char **environ;

static char * wrapperDir = WRAPPER_DIR;

int main(int argc, char * * argv)
{
    char self[PATH_MAX];
    
    int len = readlink("/proc/self/exe", self, sizeof(self) - 1);
    if (len == -1) abort();
    self[len] = 0;

    //printf("self = %s, ch = %c\n", self, self[strlen(wrapperDir)]);

    
    /* Make sure that we are being executed from the right location,
       i.e., `wrapperDir'.  This is to prevent someone from
       creating hard link `X' from some other location, along with a
       false `X.real' file, to allow arbitrary programs from being
       executed setuid. */
    if ((strncmp(self, wrapperDir, sizeof(wrapperDir)) != 0) ||
        (self[strlen(wrapperDir)] != '/'))
        abort();

    
    /* Make *really* *really* sure that we were executed as `self',
       and not, say, as some other setuid program.  That is, our
       effective uid/gid should match the uid/gid of `self'. */
    //printf("%d %d\n", geteuid(), getegid());

    struct stat st;
    if (lstat(self, &st) == -1) abort();

    //printf("%d %d\n", st.st_uid, st.st_gid);
    
    if ((st.st_mode & S_ISUID) != 0 &&
        st.st_uid != geteuid())
        abort();

    if ((st.st_mode & S_ISGID) != 0 &&
        st.st_gid != getegid())
        abort();

    /* And, of course, we shouldn't be writable. */
    if (st.st_mode & (S_IWGRP | S_IWOTH))
        abort();


    /* Read the path of the real (wrapped) program from <self>.real. */
    char realFN[PATH_MAX + 10];
    if (snprintf(realFN, sizeof(realFN), "%s.real", self) >= sizeof(realFN))
        abort();

    int fdSelf = open(realFN, O_RDONLY);
    if (fdSelf == -1) abort();

    char real[PATH_MAX];
    len = read(fdSelf, real, PATH_MAX);
    if (len == -1) abort();
    if (len == sizeof(real)) abort();
    real[len] = 0;

    close(fdSelf);
    
    //printf("real = %s, len = %d\n", real, len);

    execve(real, argv, environ);
    
    exit(1);
}
