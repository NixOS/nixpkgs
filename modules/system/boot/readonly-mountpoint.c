#include <sys/statvfs.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char ** argv) {
	struct statvfs stat;
	int res;
	if (argc != 2) {
		fprintf(stderr, "Usage: %s PATH", argv[0]);
		exit(2);
	}
	if(statvfs(argv[1], &stat) != 0) {
		perror("statvfs");
		exit(3);
	}
	if (stat.f_flag & ST_RDONLY)
		exit(0);
	else
		exit(1);
}

