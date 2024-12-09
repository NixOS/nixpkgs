#include <stdio.h>
#include <string.h>

static const char from[] =  "/usr/lib/ext/dell/omreg.cfg";
static const char to[] = "@to@";

int access_wrapper(const char *fn, int mode)
{
	if (!strcmp(fn, from)) {
		printf("access_wrapper.c: Replacing path '%s' with '%s'\n", from, to);
		fn = to;
	}
	return access(fn, mode);
}

FILE* fopen_wrapper(const char* fn, const char* mode)
{
	if (!strcmp(fn, from)) {
		printf("fopen_wrapper.c: Replacing path '%s' with '%s'\n", from, to);
		fn = to;
	}
	return fopen(fn, mode);
}
