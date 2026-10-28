/**
 * Adapted from `man cap_from_text`
 * https://git.kernel.org/pub/scm/libs/libcap/libcap.git/tree/doc/cap_from_text.3?id=e1e79bcbaec103c074dd4d501692ef8ff41d75ae
 */

#include <stdlib.h>
#include <stdio.h>
#include <sys/capability.h>

#define handle_error(msg) do { perror(msg); exit(EXIT_FAILURE); } while (0)

int main(int argc, char *argv[]) {
   cap_t caps;
   char *txt_caps;

   if (argc != 2) {
       fprintf(stderr, "%s <textual-cap-set>\n", argv[0]);
       exit(EXIT_FAILURE);
   }

   caps = cap_from_text(argv[1]);
   if (caps == NULL)
       handle_error("cap_from_text");

   txt_caps = cap_to_text(caps, NULL);
   if (txt_caps == NULL)
       handle_error("cap_to_text");

   printf("caps_to_text() returned \"%s\"\n", txt_caps);

   if (cap_free(txt_caps) != 0 || cap_free(caps) != 0)
       handle_error("cap_free");

   exit(EXIT_SUCCESS);
}
