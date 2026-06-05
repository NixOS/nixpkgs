/* Brgen4 search for configuration under `/etc/opt/brother/scanner/brscan4`. This
   LD_PRELOAD library intercepts execvp(), open and open64 calls to redirect them to
   the corresponding location in $out. Also support specifying an alternate
   file name for `brsanenetdevice4.cfg` which otherwise is invariable
   created at `/etc/opt/brother/scanner/brscan4`*/

#define _GNU_SOURCE
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <limits.h>
#include <string.h>
#include <dirent.h>

char origDir [] = "/etc/opt/brother/scanner/brscan4";
char realDir [] = OUT "/opt/brother/scanner/brscan4";

char devCfgFileNameEnvVar [] = "BRSANENETDEVICE4_CFG_FILENAME";
char devCfgFileName [] = "/etc/opt/brother/scanner/brscan4//brsanenetdevice4.cfg";

const char * rewrite(const char * path, char * buf)
{
    if (strncmp(path, devCfgFileName, sizeof(devCfgFileName)) == 0) {

      const char* newCfgFileName = getenv(devCfgFileNameEnvVar);
      if (!newCfgFileName) return path;

      if (snprintf(buf, PATH_MAX, "%s", newCfgFileName) >= PATH_MAX)
          abort();
      return buf;
    }

    if (strncmp(path, origDir, sizeof(origDir) - 1) != 0) return path;
    if (snprintf(buf, PATH_MAX, "%s%s", realDir, path + sizeof(origDir) - 1) >= PATH_MAX)
        abort();
    return buf;
}

const char* findAndReplaceFirstOccurence(const char* inStr, const char* subStr, 
                                         const char* replaceStr, 
                                         char* buf, unsigned maxBuf)
{
    const char* foundStr = strstr(inStr, subStr);
    if (!foundStr)
      return inStr;

    const unsigned inStrLen = strlen(inStr);
    const unsigned subStrLen = strlen(subStr);
    const unsigned replaceStrLen = strlen(replaceStr);

    const unsigned precedingStrLen = foundStr - inStr;
    if (precedingStrLen + 1 > maxBuf)
      return NULL;

    const unsigned followingStrPos = precedingStrLen + subStrLen;
    const unsigned followingStrLen = inStrLen - followingStrPos;

    strncpy(buf, inStr, precedingStrLen);
    unsigned outLength = precedingStrLen;

    if (outLength + replaceStrLen + 1 > maxBuf)
      return NULL;

    strncpy(buf + outLength, replaceStr, replaceStrLen);
    outLength += replaceStrLen;
    
    if (outLength + followingStrLen + 1 > maxBuf)
      return NULL;

    strncpy(buf + outLength, inStr + followingStrPos, followingStrLen);
    outLength += followingStrLen;
    
    buf[outLength] = '\0';

    return buf;
}

const char* rewriteSystemCall(const char* command, char* buf, unsigned maxBuf)
{

    const char* foundStr = strstr(command, devCfgFileName);
    if (!foundStr)
      return command;

    const char* replaceStr = getenv(devCfgFileNameEnvVar);
    if (!replaceStr) return command;

    const char* result = 
      findAndReplaceFirstOccurence(command, devCfgFileName, replaceStr, buf, maxBuf);

    if (!result)
      abort();

    return result;
}

int execvp(const char * path, char * const argv[])
{
    int (*_execvp) (const char *, char * const argv[]) = dlsym(RTLD_NEXT, "execvp");
    char buf[PATH_MAX];
    return _execvp(rewrite(path, buf), argv);
}


int open(const char *path, int flags, ...)
{
    char buf[PATH_MAX];
    int (*_open) (const char *, int, mode_t) = dlsym(RTLD_NEXT, "open");
    mode_t mode = 0;
    if (flags & O_CREAT) {
        va_list ap;
        va_start(ap, flags);
        mode = va_arg(ap, mode_t);
        va_end(ap);
    }
    return _open(rewrite(path, buf), flags, mode);
}

int open64(const char *path, int flags, ...)
{
    char buf[PATH_MAX];
    int (*_open64) (const char *, int, mode_t) = dlsym(RTLD_NEXT, "open64");
    mode_t mode = 0;
    if (flags & O_CREAT) {
        va_list ap;
        va_start(ap, flags);
        mode = va_arg(ap, mode_t);
        va_end(ap);
    }
    return _open64(rewrite(path, buf), flags, mode);
}

FILE* fopen(const char* path, const char* mode)
{
  char buf[PATH_MAX];
	FILE* (*_fopen) (const char*, const char*) = dlsym(RTLD_NEXT, "fopen");

	return _fopen(rewrite(path, buf), mode);
}

FILE *fopen64(const char *path, const char *mode)
{
  char buf[PATH_MAX];
	FILE* (*_fopen64) (const char*, const char*) = dlsym(RTLD_NEXT, "fopen64");

	return _fopen64(rewrite(path, buf), mode);
}

DIR* opendir(const char* path)
{
  char buf[PATH_MAX];
	DIR* (*_opendir) (const char*) = dlsym(RTLD_NEXT, "opendir");

	return _opendir(rewrite(path, buf));
}

#define SYSTEM_CMD_MAX 512

int system(const char *command)
{
    char buf[SYSTEM_CMD_MAX];
    int (*_system) (const char*) = dlsym(RTLD_NEXT, "system");

    const char* newCommand = rewriteSystemCall(command, buf, SYSTEM_CMD_MAX);
    return _system(newCommand);
}
