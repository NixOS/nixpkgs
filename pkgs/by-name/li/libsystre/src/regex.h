/*
  regex.h - POSIX regular expression API definitions

  This header is under public domain.

*/

#ifndef _REGEX_H
#define _REGEX_H 1

#include <tre/tre.h>

#ifdef __cplusplus
extern "C" {
#endif

int regcomp(regex_t *preg, const char *pattern,
       int cflags);
size_t regerror(int errcode, const regex_t *preg,
       char *errbuf, size_t errbuf_size);
int regexec(const regex_t *preg, const char *string,
       size_t nmatch, regmatch_t pmatch[], int eflags);
void regfree(regex_t *preg);

#ifdef __cplusplus
}
#endif

#endif /* regex.h */


