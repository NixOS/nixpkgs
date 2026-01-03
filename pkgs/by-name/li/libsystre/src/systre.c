/*
  systre.c - TRE wrapper

  This software is released under a BSD-style license.
  See the file COPYING  for details and copyright.

*/

#include "regex.h"

int
regcomp(regex_t *preg, const char *regex, int cflags)
{
  return tre_regcomp(preg, regex, cflags);
}

void
regfree(regex_t *preg)
{
  tre_regfree(preg);
}

size_t
regerror(int errcode, const regex_t *preg, char *errbuf, size_t errbuf_size)
{
  return tre_regerror(errcode, preg, errbuf, errbuf_size);
}

int
regexec(const regex_t *preg, const char *str,
	size_t nmatch, regmatch_t pmatch[], int eflags)
{
  return tre_regexec(preg, str, nmatch, pmatch, eflags);
}


