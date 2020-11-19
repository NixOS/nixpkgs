diff --git a/Source/Misc/libr-bfd.c b/Source/Misc/libr-bfd.c
index eb7481dd..ad81318f 100644
--- a/Source/Misc/libr-bfd.c
+++ b/Source/Misc/libr-bfd.c
@@ -25,7 +25,6 @@
  *
  */
 #ifdef LINUX
-#define HAVE_BFD_2_34
 #include "libr.h"
 /* File access */
 #include <fcntl.h>
