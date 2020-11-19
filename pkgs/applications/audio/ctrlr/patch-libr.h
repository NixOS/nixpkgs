diff --git a/Source/Misc/include/libr.h b/Source/Misc/include/libr.h
index 4c190c76..2ad360da 100644
--- a/Source/Misc/include/libr.h
+++ b/Source/Misc/include/libr.h
@@ -27,6 +27,10 @@
  */
 
 #include <sys/types.h>
+
+/* Define to the version of this package. */
+#define PACKAGE_VERSION ""
+
 #include <bfd.h>
 
 #define ENABLE_NLS 1
@@ -110,9 +114,6 @@
 /* Define to the home page for this package. */
 #define PACKAGE_URL ""
 
-/* Define to the version of this package. */
-#define PACKAGE_VERSION ""
-
 /* Define to 1 if you have the ANSI C header files. */
 #define STDC_HEADERS 1
 
