#define _GNU_SOURCE
#include <dirent.h>
#include <errno.h>
#include <unistd.h>
#include <fcntl.h>
#include <grp.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdnoreturn.h>
#include <sys/stat.h>
#include <sys/prctl.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <sys/xattr.h>
#include <attr/xattr.h>
#include <bsd/string.h>
#include <openssl/md5.h>
#include <ftw.h>



/*
 * Linux kernel patches to add  fsetxattrat, fgetxattrat, flistxattrat, fremovexattrat syscalls:
 *
 * https://lkml.org/lkml/2014/1/21/266
 * https://lkml.org/lkml/2014/1/21/264
 * https://lkml.org/lkml/2014/1/21/192
 * https://lkml.org/lkml/2014/1/21/207
 */

#ifdef DEBUG
#define DEBUG_TEST 1
#else
#define DEBUG_TEST 0
#endif


/*
 * error handling helper functions
 */

#define RAISE(code) raise_((code), __FILE__, __LINE__)
noreturn static inline void raise_(int code, const char *file, int line) {
    fprintf (stderr, "%s:%d: unexpected error=%d (%s).\n", file, line, code, strerror(code));
    abort();
}

#define ENFORCE(ret) enforce((ret), __FILE__, __LINE__)
static inline int enforce(int ret, const char *file, int line) {
    if (ret < 0) {
        raise_(errno, file, line);
    } else {
        return ret;
    }
}

#define debug_print(fmt, ...) do { if (DEBUG_TEST) fprintf(stderr, "%s:%d:%s(): " fmt, __FILE__, __LINE__, __func__, __VA_ARGS__); } while (0)


//
// global variables
//
#define OPEN_MAX 20

#define H_STATIC 0
#define H_VOLATILE 1

static uid_t ruid, euid;
static gid_t rgid, egid;

static char target_old[PATH_MAX];
static char target_new[PATH_MAX];
static char home[PATH_MAX];




//
// symbolic link
//

static void symlink_md5_measure(int fd, char* hash) {
    char buf[PATH_MAX];
    ssize_t nbytes;

    buf[PATH_MAX-1] = '\0';
    nbytes = ENFORCE(readlinkat(fd, "", buf, PATH_MAX));

    if (nbytes == PATH_MAX && buf[PATH_MAX-1] != '\0') {
        RAISE(ENAMETOOLONG);
    }

    // Calculate MD5 hash of symlink target

    MD5_CTX mdContext;
    
    MD5_Init (&mdContext);
    MD5_Update (&mdContext, buf, nbytes);
    MD5_Final ((unsigned char*)hash,&mdContext);
}


static void symlink_md5_update(const int fd, const char* path, const char* fn, int setvolatile) {
    char hash[2*MD5_DIGEST_LENGTH];

    if (setvolatile == H_STATIC) {
        symlink_md5_measure(fd, hash);
        MD5((unsigned char*)fn,strlen(fn),(unsigned char*)&hash[MD5_DIGEST_LENGTH]);


        ENFORCE(seteuid(euid));
        ENFORCE(setegid(egid));
        // TODO: hope for fsetxattrat system call, and then use fd directly
        ENFORCE(lsetxattr(path, "trusted.managed", hash, sizeof(char)*2*MD5_DIGEST_LENGTH, 0));
        ENFORCE(setegid(rgid));
        ENFORCE(seteuid(ruid));
    } else {
        MD5((unsigned char*)fn,strlen(fn),(unsigned char*)&hash[0]);

        ENFORCE(seteuid(euid));
        ENFORCE(setegid(egid));
        // TODO: hope for fsetxattrat system call, and then use fd directly
        ENFORCE(lsetxattr(path, "trusted.managed", hash, sizeof(char)*MD5_DIGEST_LENGTH, 0));
        ENFORCE(setegid(rgid));
        ENFORCE(seteuid(ruid));
    }
}


static int symlink_md5_verify(const int fd, const char* path, const char* fn, int allowvolatile) {
    char hash_attr[2*MD5_DIGEST_LENGTH];
    char hash_file[2*MD5_DIGEST_LENGTH];
    int size;


    ENFORCE(seteuid(euid));
    ENFORCE(setegid(egid));
    // TODO: hope for fsetxattrat system call, and then use fd directly
    size = ENFORCE(lgetxattr(path, "trusted.managed", hash_attr, sizeof(char)*2*MD5_DIGEST_LENGTH));
    ENFORCE(setegid(rgid));
    ENFORCE(seteuid(ruid));

    debug_print("symlink verify: attr hash: `%i`:`%s`\n", size, hash_attr);

    if (size == sizeof(char)*2*MD5_DIGEST_LENGTH) {
        symlink_md5_measure(fd, hash_file);
        MD5((unsigned char*)fn,strlen(fn),(unsigned char*)&hash_file[MD5_DIGEST_LENGTH]);

        if (strncmp(hash_file, hash_attr, 2*MD5_DIGEST_LENGTH) == 0) {
            return 1;
        } else {
            return 0;
        }
    } else if (allowvolatile == H_VOLATILE && size == sizeof(char)*MD5_DIGEST_LENGTH) {
        MD5((unsigned char*)fn,strlen(fn),(unsigned char*)&hash_file[0]);
        if (strncmp(hash_file, hash_attr, MD5_DIGEST_LENGTH) == 0) {
            return 1;
        } else {
            return 0;
        }
    } else {
        return 0;
    };
}



//
// regular file
//

static void file_md5_measure(int fd, char* hash) {
    int fd_;

    fd_ = ENFORCE(dup(fd));
    FILE *inFile = fdopen (fd_, "rb");

    if (inFile == NULL) {
        RAISE(errno);
    }

    MD5_CTX mdContext;
    unsigned char data[1024];
    int bytes;

    MD5_Init (&mdContext);
    while ((bytes = fread (data, 1, 1024, inFile)) != 0)
        MD5_Update (&mdContext, data, bytes);
    if(ferror(inFile))
        RAISE(ferror(inFile));
    MD5_Final ((unsigned char*)hash,&mdContext);

    ENFORCE(fclose(inFile)); // also closes fd_
}


static void file_md5_update(int fd, const char* fn, int setvolatile) {
    char hash[2*MD5_DIGEST_LENGTH];


    if (setvolatile == H_STATIC) {
        file_md5_measure(fd, hash);
        MD5((unsigned char*)fn,strlen(fn),(unsigned char*)&hash[MD5_DIGEST_LENGTH]);

        ENFORCE(seteuid(euid));
        ENFORCE(setegid(egid));
        // TODO: hope for fsetxattrat system call, and then use fd directly
        ENFORCE(fsetxattr(fd, "trusted.managed", hash, sizeof(char)*2*MD5_DIGEST_LENGTH, 0));
        ENFORCE(setegid(rgid));
        ENFORCE(seteuid(ruid));
    } else {
        MD5((unsigned char*)fn,strlen(fn),(unsigned char*)&hash[0]);

        ENFORCE(seteuid(euid));
        ENFORCE(setegid(egid));
        // TODO: hope for fsetxattrat system call, and then use fd directly
        ENFORCE(fsetxattr(fd, "trusted.managed", hash, sizeof(char)*MD5_DIGEST_LENGTH, 0));
        ENFORCE(setegid(rgid));
        ENFORCE(seteuid(ruid));
    }
}


static int file_md5_verify(const int fd, const char* fn, int allowvolatile) {
    char hash_attr[2*MD5_DIGEST_LENGTH];
    char hash_file[2*MD5_DIGEST_LENGTH];
    int size;

    ENFORCE(seteuid(euid));
    ENFORCE(setegid(egid));
    size = ENFORCE(fgetxattr(fd, "trusted.managed", hash_attr, sizeof(char)*2*MD5_DIGEST_LENGTH));
    ENFORCE(setegid(rgid));
    ENFORCE(seteuid(ruid));

    if (size == sizeof(char)*2*MD5_DIGEST_LENGTH) {
        file_md5_measure(fd, hash_file);
        MD5((unsigned char*)fn,strlen(fn),(unsigned char*)&hash_file[MD5_DIGEST_LENGTH]);

        if (strncmp(hash_file, hash_attr, 2*MD5_DIGEST_LENGTH) == 0) {
            return 1;
        } else {
            return 0;
        }
    } else if (allowvolatile == H_VOLATILE && size == sizeof(char)*MD5_DIGEST_LENGTH) {
        MD5((unsigned char*)fn,strlen(fn),(unsigned char*)&hash_file[0]);
        if (strncmp(hash_file, hash_attr, MD5_DIGEST_LENGTH) == 0) {
            return 1;
        } else {
            return 0;
        }
    } else {
        return 0;
    };
}


static inline int fd_md5_exists(const int fd, const char* path) {
    int err;
    if (path == NULL) {
        ENFORCE(seteuid(euid));
        ENFORCE(setegid(egid));
        err = fgetxattr(fd, "trusted.managed", NULL, 0);
        ENFORCE(setegid(rgid));
        ENFORCE(seteuid(ruid));
    } else {
        ENFORCE(seteuid(euid));
        ENFORCE(setegid(egid));
        // TODO: hope for fsetxattrat system call, and then use fd directly
        err = lgetxattr(path, "trusted.managed", NULL, 0);
        ENFORCE(setegid(rgid));
        ENFORCE(seteuid(ruid));
    }

    if (err != -1)
        return 1;
    else if (errno == ENOATTR)
        return 0;
    else
        RAISE(errno);
}


static inline int substr (const char* input, int offset, char* dest)
{
  int input_len = strlen (input);

  if (offset > input_len)
     return -1;

  strncpy (dest, input + offset, input_len);
  return 0;
}


static void create_filename(char* buffer, const char* directory, const char* subdirectory, const char* fn) {
    // check for buffer overflow
    if (strlen(directory) + strlen(subdirectory) + strlen(fn) + 1 > PATH_MAX)
        RAISE(ENAMETOOLONG);
    strcat(strcat(strcat(buffer, directory), subdirectory), fn);
}

 
static int dir_empty(int fd)
{
    struct dirent *ent;
    int ret = 0;
 
    int fd_ = dup(fd);
    DIR *d = fdopendir(fd_);
    if (!d)
        RAISE(errno);
 
    errno = 0;
    while ((ent = readdir(d))) {
        if (ent == NULL && errno != 0)
            RAISE(errno);
        if (!strcmp(ent->d_name, ".") || !(strcmp(ent->d_name, "..")))
            continue;
        ret = 1;
        break;
    }
 
    ENFORCE(closedir(d));
    return ret;
}
 

inline static int rmFiles(const char *pathname, const struct stat *sbuf, int type, struct FTW *ftwb) {
    return remove(pathname);
}

inline static int rmtree(const char *path) {
    // Delete the directory and its contents by traversing the tree in reverse order, without crossing mount boundaries and symbolic links
    return nftw(path, rmFiles, OPEN_MAX, FTW_DEPTH|FTW_MOUNT|FTW_PHYS);
}


static unsigned int read_int(const char *fn, int octal) {
    char line[256];
    
    FILE* f = fopen(fn, "r");
    if (f == NULL)
        RAISE(errno); 
    if(fgets(line, sizeof(line), f) == NULL) {
        printf("ERROR: file ‘%s’ does not contain required data...\n", fn);
        abort();
    }
    line[strcspn(line, "\r\n")] = '\0';
    ENFORCE(fclose(f));
    unsigned int x;
    if (octal) {
        if (sscanf(line, "%o", &x) == EOF)
            RAISE(errno);
    } else {
        if (sscanf(line, "%u", &x) == EOF)
            RAISE(errno);
    }
    return x;
}




static int managed_unlink(const char *fpath, const struct stat *sb, int typeflag, struct FTW *ftwbuf) {
    char fn[PATH_MAX] = "";
    int x;
    debug_print("fpath: `%s`...\n", fpath);

    // make sure the subsequent call to substr can not have a buffer overflow
    if (strlen(fpath) + 1 > PATH_MAX)
        RAISE(ENAMETOOLONG);
    x = substr(fpath, strlen(target_old) + strlen("/sources"), fn);

    debug_print("filename: `%s`...\n", fn);

    if (x == 0 && strlen(fn) > 0) {
        char target_new_fn[PATH_MAX] = "";
        create_filename(target_new_fn, target_new, "/sources", fn);

        struct stat sb_target_new_fn;
        // check if new_target also contains a file for the current path
        x = lstat(target_new_fn, &sb_target_new_fn);
        if (x != 0 && errno == ENOENT) {
            char home_fn[PATH_MAX] = "";
            create_filename(home_fn, home, "", fn);
            debug_print("home filename: `%s`...\n", home_fn);

            struct stat sb_home_fn;
            if (lstat(home_fn, &sb_home_fn)==0) {
                int fd_home_fn;
                switch (sb_home_fn.st_mode & S_IFMT) {
                    // symbolic link
                    case S_IFLNK:
                        fd_home_fn = ENFORCE(open(home_fn, O_RDONLY | O_PATH | O_NOFOLLOW));
                        if (fd_md5_exists(fd_home_fn, home_fn)) {
                            if (symlink_md5_verify(fd_home_fn, home_fn, fn, H_VOLATILE)) {
                                printf("removing obsolete symlink ‘%s’...\n", home_fn);
                                ENFORCE(unlinkat(fd_home_fn, "", 0));
                            } else {
                                printf("WARNING: obsolete symlink ‘%s’ has unmanaged target...\n", home_fn);
                            }
                        } else {
                            printf("WARNING: file ‘%s’ should be managed and it would now be obsolete...\n", home_fn);
                        }
                        ENFORCE(close(fd_home_fn));
                        break;
                    // regular file
                    case S_IFREG:
                        fd_home_fn = ENFORCE(open(home_fn, O_RDONLY));
                        if (fd_md5_exists(fd_home_fn, NULL)) {
                            if (file_md5_verify(fd_home_fn, fn, H_VOLATILE)) {
                                printf("removing obsolete and unchanged file ‘%s’...\n", home_fn);
                                ENFORCE(unlinkat(fd_home_fn, "", 0));
                            } else {
                                printf("WARNING: obsolete file ‘%s’ has unmanaged content...\n", home_fn);
                            }
                        } else {
                            printf("WARNING: file ‘%s’ should be managed and it would now be obsolete...\n", home_fn);
                        }
                        ENFORCE(close(fd_home_fn));
                        break;
                    // directory
                    case S_IFDIR:
                        fd_home_fn = ENFORCE(open(home_fn, O_RDONLY | O_DIRECTORY));
                        if (fd_md5_exists(fd_home_fn, NULL)) {
                            if (dir_empty(fd_home_fn) == 1) {
                                printf("removing obsolete and empty directory ‘%s’...\n", home_fn);
                                ENFORCE(unlinkat(fd_home_fn, "", 0));
                            } else if (file_md5_verify(fd_home_fn, fn, H_VOLATILE)) {
                                printf("removing obsolete and empty directory ‘%s’...\n", home_fn);
                                ENFORCE(rmtree("$home/$fn"));
                            } else {
                                printf("WARNING: obsolete directory ‘%s’ contains unmanaged files...\n", home_fn);
                            }
                        } else {
                            printf("WARNING: file ‘%s’ should be managed and it would now be obsolete...\n", home_fn);
                        }
                        ENFORCE(close(fd_home_fn));
                        break;
                    default:
                        printf("WARNING: file ‘%s’ is of unmanageable type...\n", home_fn);
                }
            } else {
                if (errno == ENOENT)
                    printf("WARNING: obsolete file ‘%s’ does not exist anymore...\n", home_fn);
                else
                    RAISE(errno);
            }
        } else if (x != 0) {
            RAISE(errno);
        }
        return 0;
    } else {
        return 0;
    }
}




static inline int exists(const char* path, struct stat* sb) {
    debug_print("check if path `%s` exists...", path);
    int x = lstat(path, sb);
    if (x == 0) {
        return 1;
    } else if (x != 0 && errno == ENOENT) {
        return 0;
    } else {
        RAISE(errno);
    }
}


static void atomic_switch(const char* fn, const char* home_fn_tmp, const char* home_fn) {
    int allow_volatile;

    char target_new_volatile[PATH_MAX] = "";
    create_filename(target_new_volatile, target_new, "/volatiles", fn);
    debug_print("target new volatile: `%s`...\n", target_new_volatile);
            
    struct stat sb_target_new_volatile;
    // check if new_target also contains a file for the current path
    if (exists(target_new_volatile, &sb_target_new_volatile)) {
        debug_print("target new `%s` is VOLATILE...\n", home_fn);
        allow_volatile = H_VOLATILE;
    } else {
        debug_print("target new `%s` is STATIC...\n", home_fn);
        allow_volatile = H_STATIC;
    }


    struct stat sb_home_fn_tmp;
    if (ENFORCE(lstat(home_fn_tmp, &sb_home_fn_tmp))==0) {
        int fd_home_fn_tmp;
        switch (sb_home_fn_tmp.st_mode & S_IFMT) {
            // symbolic link
            case S_IFLNK:
                debug_print("switch symbolic link `%s`...\n", home_fn_tmp);
                fd_home_fn_tmp = ENFORCE(open(home_fn_tmp, O_RDONLY | O_PATH | O_NOFOLLOW));
                symlink_md5_update(fd_home_fn_tmp, home_fn_tmp, fn, allow_volatile);
                ENFORCE(close(fd_home_fn_tmp));
                break;
            // regular file
            case S_IFREG:
                debug_print("switch regular file `%s`...\n", home_fn_tmp);
                fd_home_fn_tmp = ENFORCE(open(home_fn_tmp, O_RDONLY));
                file_md5_verify(fd_home_fn_tmp, fn, allow_volatile);
                ENFORCE(close(fd_home_fn_tmp));
                break;
            // directory
            case S_IFDIR:
                debug_print("switch directory `%s`...\n", home_fn_tmp);
                fd_home_fn_tmp = ENFORCE(open(home_fn_tmp, O_RDONLY | O_DIRECTORY));
                file_md5_update(fd_home_fn_tmp, fn, allow_volatile);
                ENFORCE(close(fd_home_fn_tmp));
                break;
            default:
                printf("ERROR: file ‘%s’ is of unmanageable type...\n", home_fn_tmp);
                exit(-1);
        }
    } else {
        printf("ERROR: INTERNAL ERROR: ‘%s’ does not exist...\n", home_fn_tmp);
        abort();
    }


    char buffer[PATH_MAX] = "";
    create_filename(buffer, target_new, "/modes", fn);

    struct stat sb_target_new_mode;
    if (exists(buffer, &sb_target_new_mode)) {
        create_filename(buffer, target_new, "/uids", fn);
        unsigned int uid = read_int(buffer, 0);
        
        create_filename(buffer, target_new, "/gids", fn);
        unsigned int gid = read_int(buffer, 0);
        
        create_filename(buffer, target_new, "/modes", fn);
        unsigned int mode = read_int(buffer, 1);


        ENFORCE(lstat(home_fn_tmp, &sb_home_fn_tmp));
        ENFORCE(lchown(home_fn_tmp, uid, gid));

        if ((sb_home_fn_tmp.st_mode & S_IFMT) != S_IFLNK);
            ENFORCE(chmod(home_fn_tmp, mode));
    }

    ENFORCE(rename(home_fn_tmp, home_fn)); //TODO:: switch to renameat
}



static int managed_link(const char *fpath, const struct stat *sb, int typeflag, struct FTW *ftwbuf) {
    debug_print("fpath: `%s`...\n", fpath);

    char fn[PATH_MAX] = "";
    int x;

    // make sure the subsequent call to substr can not have a buffer overflow
    if (strlen(fpath) + 1 > PATH_MAX)
        RAISE(ENAMETOOLONG);
    x = substr(fpath, strlen(target_new) + strlen("/sources"), fn);

    debug_print("filename: `%s`...\n", fn);

    if (x == 0 && strlen(fn) > 0) {
        char home_fn[PATH_MAX] = "";
        create_filename(home_fn, home, "", fn);
        debug_print("home filename: `%s`...\n", home_fn);

        char home_fn_tmp[PATH_MAX] = "";
        create_filename(home_fn_tmp, home, fn, ".nixup-temporary-managed-resource");
        debug_print("home filename tmp: `%s`...\n", home_fn_tmp);

        struct stat sb_home_fn;
        if (typeflag == FTW_D && typeflag == FTW_DP) {
            debug_print("linking: target `%s` is a directory...\n", fpath);
            if (!exists(home_fn, &sb_home_fn)) {
                unlink(home_fn_tmp);

                ENFORCE(mkdir(home_fn_tmp, S_IRWXU | S_IRGRP | S_IXGRP | S_IROTH | S_IXOTH)); //TODO: hope for O_TMPDIR option in mkdir/open

                int fd_home_fn = ENFORCE(open(home_fn, O_RDONLY | O_DIRECTORY));
                file_md5_update(fd_home_fn, fn, H_VOLATILE);
                ENFORCE(close(fd_home_fn));

                ENFORCE(rename(home_fn_tmp, home_fn)); //TODO:: switch to renameat
            } else {
                return 0;
            }
        } else if (typeflag == FTW_F || typeflag == FTW_SL) {
            debug_print("linking: target `%s` is a file or a symbolic link...\n", fpath);
            // make sure no un-managed data is lost
            // check that a managed content did not change and so can safely be overridden
            if (exists(home_fn, &sb_home_fn)) {
                debug_print("linking: file `%s` exists in home with mode '%lo'...\n", home_fn, (unsigned long) sb_home_fn.st_mode);
                int fd_home_fn;
                switch (sb_home_fn.st_mode & S_IFMT) {
                    // symbolic link
                    case S_IFLNK:
                        debug_print("linking: existing file `%s` is a symbolic link...\n", home_fn);
                        fd_home_fn = ENFORCE(open(home_fn, O_RDONLY | O_PATH | O_NOFOLLOW));
                        if (fd_md5_exists(fd_home_fn, home_fn)) {
                            if (1!=symlink_md5_verify(fd_home_fn, home_fn, fn, H_VOLATILE)) {
                                printf("ERROR: managed symbolic link ‘%s’ contains an unmanaged reference...\n", home_fn);
                                exit(-1);
                            }
                        } else {
                            printf("ERROR: file ‘%s’ already exists and so path cannot be managed...\n", home_fn);
                            exit(-1);
                        }
                        ENFORCE(close(fd_home_fn));
                        break;
                    // regular file
                    case S_IFREG:
                        debug_print("linking: existing file `%s` is a regular file...\n", home_fn);
                        fd_home_fn = ENFORCE(open(home_fn, O_RDONLY));
                        if (fd_md5_exists(fd_home_fn, NULL)) {
                            if (1!=file_md5_verify(fd_home_fn, fn, H_VOLATILE)) {
                                printf("ERROR: managed file ‘%s’ contains unmanaged data...\n", home_fn);
                                exit(-1);
                            }
                        } else {
                            printf("ERROR: file ‘%s’ already exists and so path cannot be managed...\n", home_fn);
                            exit(-1);
                        }
                        ENFORCE(close(fd_home_fn));
                        break;
                    // directory
                    case S_IFDIR:
                        debug_print("linking: existing file `%s` is a directory...\n", home_fn);
                        fd_home_fn = ENFORCE(open(home_fn, O_RDONLY | O_DIRECTORY));
                        if (fd_md5_exists(fd_home_fn, NULL)) {
                            if (file_md5_verify(fd_home_fn, fn, H_VOLATILE)) {
                                printf("ERROR: managed directory ‘%s’ contains unmanaged data...\n", home_fn);
                                exit(-1);
                            }
                        } else {
                            printf("ERROR: directory ‘%s’ already exists and so path cannot be managed...\n", home_fn);
                            exit(-1);
                        }
                        ENFORCE(close(fd_home_fn));
                        break;
                    default:
                        debug_print("linking: existing file `%s` is of type `%lo`...\n", home_fn, (unsigned long) (sb_home_fn.st_mode & S_IFMT));
                        printf("ERROR: file ‘%s’ already exists and so path cannot be managed...\n", home_fn);
                        exit(-1);
                }
            }

            char target_new_dynamic[PATH_MAX] = "";
            create_filename(target_new_dynamic, target_new, "/dynamics", fn);
            debug_print("target new dynamic: `%s`...\n", target_new_dynamic);
            
            struct stat sb_target_new_dynamic;
            if (exists(target_new_dynamic, &sb_target_new_dynamic)) {
                debug_print("new target `%s` is dynamic...\n", target_new_dynamic);
                int pid = ENFORCE(fork());
                int status;
                if (pid == 0) {
                    // TODO: check whether ftw uses O_CLOXEC and if not switch ftw to fts
                    //       so that all file descriptors can be closed properly before execve
                    ENFORCE(prctl(PR_SET_PDEATHSIG, SIGTERM));
                    ENFORCE(setgroups(1, &rgid));
                    ENFORCE(setregid(rgid, rgid));
                    ENFORCE(setreuid(rgid, ruid));
            
                    char *cargv[] = { NULL, home_fn, home_fn_tmp, NULL };
                    char *cenvp[] = { NULL };
                    ENFORCE(execve(fpath, cargv, cenvp));
                } else {
                    ENFORCE(waitpid(pid, &status, 0));
                    if (WIFEXITED(status) != 0 || WEXITSTATUS(status) != 0) {
                        printf("ERROR: dynamically executed subroutine `%s` did not succeed...\n", fpath);
                        abort();
                    }
                }
            
                atomic_switch(fn, home_fn_tmp, home_fn);
            } else {
                char target_new_fn[PATH_MAX] = "";
                create_filename(target_new_fn, target_new, "/sources", fn);

                debug_print("new target `%s` is not dynamic...\n", target_new_fn);

                if ((sb_home_fn.st_mode & S_IFMT) == S_IFDIR)
                    ENFORCE(rmtree(home_fn));
    

                char target_new_mode[PATH_MAX] = "";
                create_filename(target_new_mode, target_new, "/modes", fn);

                struct stat sb_target_new_mode;
                if (exists(target_new_mode, &sb_target_new_mode)) {
                    unlink(home_fn_tmp); // TODO: proper error handling

                    FILE *from = fopen(target_new_fn, "r");
                    FILE *to = fopen(home_fn_tmp, "w");
                    char buffer[BUFSIZ];
                    size_t n;

                    debug_print("copy new target `%s` to  `%s`...\n", target_new_fn, home_fn_tmp);
                    while ((n = fread(buffer, sizeof(char), sizeof(buffer), from)) > 0)
                    {
                        if (ENFORCE(fwrite(buffer, sizeof(char), n, to)) != n) {
                            printf("ERROR: failed to copy from `%s` to `%s`...", target_new_fn, home_fn_tmp);
                            abort();
                        }
                    }
                    if (ferror(from))
                        RAISE(ferror(from));

                    atomic_switch(fn, home_fn_tmp, home_fn);
                } else {
                    char link[PATH_MAX];
                    if (realpath(target_new_fn, link) == NULL)
                        RAISE(errno);

                    
                    debug_print("create link: `%s`...\n", link);
                    
                    if ((sb_home_fn.st_mode & S_IFMT) == S_IFLNK) {
                        debug_print("symbolic link `%s` already exists in home...\n", home_fn);
                        char buf[PATH_MAX];
                        ssize_t nbytes;
                        
                        buf[PATH_MAX-1] = '\0';
                        nbytes = ENFORCE(readlink(home_fn, buf, PATH_MAX));
                        if (nbytes == PATH_MAX && buf[PATH_MAX-1] != '\0') {
                            RAISE(ENAMETOOLONG);
                        }
                        buf[nbytes] = '\0';

                        if (strcmp(buf, link) != 0) {
                            unlink(home_fn_tmp);
                            ENFORCE(symlink(link,home_fn_tmp));
                            atomic_switch(fn, home_fn_tmp, home_fn);
                        } else
                            debug_print("old symbolic link `%s` is identical to new one...\n", home_fn);

                    } else {
                        debug_print("symbolic link `%s` is new in home...\n", home_fn);
                        unlink(home_fn_tmp);
                        ENFORCE(symlink(link,home_fn_tmp));
                        atomic_switch(fn, home_fn_tmp, home_fn);
                    }
                }
            }
        } else {
            printf("ERROR: INTERNAL ERROR: only directories and files are allowed at `%s`...", fpath);
            abort();
        }
    }
    return 0;
}





int main(int argc, char* argv[])
{
    ruid = getuid();
    rgid = getgid();
    euid = geteuid();
    egid = getegid();
    ENFORCE(setegid(rgid));
    ENFORCE(seteuid(ruid));


    if (argc > 1) {
        char* command = argv[1];
        if (strcmp(command, "switch")==0 && argc==5) {
            strlcpy(home, argv[2], PATH_MAX);
            strlcpy(target_old, argv[3], PATH_MAX);
            strlcpy(target_new, argv[4], PATH_MAX);

            debug_print("home: `%s`...\n", home);
            debug_print("target_old: `%s`...\n", target_old);
            debug_print("target_new: `%s`...\n", target_new);
            
            char target_old_sources[PATH_MAX] = "";
            create_filename(target_old_sources, target_old, "/sources", "");
            nftw(target_old_sources, managed_unlink, OPEN_MAX, FTW_DEPTH|FTW_MOUNT|FTW_PHYS);

            char target_new_sources[PATH_MAX] = "";
            create_filename(target_new_sources, target_new, "/sources", "");
            nftw(target_new_sources, managed_link, OPEN_MAX, FTW_MOUNT|FTW_PHYS);
        } else if (strcmp(command, "link")==0 && argc==4) {
            strlcpy(home, argv[2], PATH_MAX);
            strlcpy(target_old, "", PATH_MAX);
            strlcpy(target_new, argv[3], PATH_MAX);

            char target_new_sources[PATH_MAX] = "";
            create_filename(target_new_sources, target_new, "/sources", "");
            nftw(target_new_sources, managed_link, OPEN_MAX, FTW_MOUNT|FTW_PHYS);
        } else if (strcmp(command, "unlink")==0 && argc==4) {
            strlcpy(home, argv[2], PATH_MAX);
            strlcpy(target_old, argv[3], PATH_MAX);
            strlcpy(target_new, "", PATH_MAX);

            char target_old_sources[PATH_MAX] = "";
            create_filename(target_old_sources, target_old, "/sources", "");
            nftw(target_old_sources, managed_unlink, OPEN_MAX, FTW_DEPTH|FTW_MOUNT|FTW_PHYS);
        } else if (strcmp(command, "cleanup")==0 && argc==3) {
            strlcpy(home, argv[2], PATH_MAX);
            strlcpy(target_old, "", PATH_MAX);
            strlcpy(target_new, "", PATH_MAX);
            //TODO
        } else {
            printf("Incorrect usage! Valid commands are 'switch', 'link', 'unlink' or 'cleanup' with the corresponding parameters\n");
            exit(-1);
        }
    } else {
        printf("Incorrect usage! Valid commands are 'switch', 'link', 'unlink' or 'cleanup' with the corresponding parameters\n");
        exit(-1);
    }

    exit(0);
}
