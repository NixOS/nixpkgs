#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <dirent.h>
#include <assert.h>
#include <string.h>
#include <errno.h>

/* Make sure assertions are not compiled out.  */
#undef NDEBUG

extern char **environ;

static char * wrapperDir = WRAPPER_DIR;

int main(int argc, char * * argv)
{
    char self[PATH_MAX];

    int len = readlink("/proc/self/exe", self, sizeof(self) - 1);
    assert (len > 0);
    self[len] = 0;

    /* Make sure that we are being executed from the right location,
       i.e., `wrapperDir'.  This is to prevent someone from
       creating hard link `X' from some other location, along with a
       false `X.real' file, to allow arbitrary programs from being
       executed setuid.  */
    assert ((strncmp(self, wrapperDir, sizeof(wrapperDir)) == 0) &&
	    (self[strlen(wrapperDir)] == '/'));

    /* Make *really* *really* sure that we were executed as `self',
       and not, say, as some other setuid program.  That is, our
       effective uid/gid should match the uid/gid of `self'. */
    //printf("%d %d\n", geteuid(), getegid());

    struct stat st;
    assert (lstat(self, &st) != -1);

    //printf("%d %d\n", st.st_uid, st.st_gid);
    
    assert ((st.st_mode & S_ISUID) == 0 ||
	    (st.st_uid == geteuid()));

    assert ((st.st_mode & S_ISGID) == 0 ||
	    st.st_gid == getegid());

    /* And, of course, we shouldn't be writable. */
    assert (!(st.st_mode & (S_IWGRP | S_IWOTH)));


    /* Read the path of the real (wrapped) program from <self>.real. */
    char realFN[PATH_MAX + 10];
    int realFNSize = snprintf (realFN, sizeof(realFN), "%s.real", self);
    assert (realFNSize < sizeof(realFN));

    int fdSelf = open(realFN, O_RDONLY);
    assert (fdSelf != -1);

    char real[PATH_MAX];
    len = read(fdSelf, real, PATH_MAX);
    assert (len != -1);
    assert (len < sizeof (real));
    assert (len > 0);
    real[len] = 0;

    close(fdSelf);
    
    //printf("real = %s, len = %d\n", real, len);

    execve(real, argv, environ);

    fprintf(stderr, "%s: cannot run `%s': %s\n",
        argv[0], real, strerror(errno));
    
    exit(1);
}
