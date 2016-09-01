/* Try to atomically swap two files with renameat2/RENAME_EXCHANGE,
 * falling back to swapping through a third temporary path.
 *
 * We use this for atomically (or almost atomically) updating the
 * setuid-wrapper dir, rather than using the always-atomic symlink
 * updating pattern, to avoid any potential issues with setuid
 * binaries and symlinks.
 */

#define _GNU_SOURCE
#include <fcntl.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <stdlib.h>
#include <linux/fs.h>
#include <sys/syscall.h>
#include <unistd.h>

static void move(const char * old, const char * new) {
  if (rename(old, new) == -1) {
    fprintf(stderr, "moving %s to %s: %s\n", old, new, strerror(errno));
    exit(1);
  }
}

int main(int argc, char ** argv) {
  if (argc != 4) {
    fprintf(stderr, "USAGE: %s OLD NEW TMP\n", argv[0]);
    return 1;
  }

  if (syscall(SYS_renameat2, AT_FDCWD, argv[1], AT_FDCWD, argv[2], RENAME_EXCHANGE) == -1) {
    fprintf(stderr, "directly swapping %s and %s failed: %s\nfalling back to swapping through %s\n",
	    argv[1], argv[2], strerror(errno), argv[3]);

    move(argv[1], argv[3]);
    move(argv[2], argv[1]);
    move(argv[3], argv[2]);
  }

  return 0;
}
