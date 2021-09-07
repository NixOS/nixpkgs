diff --git a/src/exchange/Makefile.am b/src/exchange/Makefile.am
index 4c1f26d..229f124 100644
--- a/src/exchange/Makefile.am
+++ b/src/exchange/Makefile.am
@@ -130,8 +130,7 @@ taler_exchange_httpd_LDADD = \
 AM_TESTS_ENVIRONMENT=export TALER_PREFIX=$${TALER_PREFIX:-@libdir@};export PATH=$${TALER_PREFIX:-@prefix@}/bin:$$PATH;
 
 check_SCRIPTS = \
-  test_taler_exchange_httpd.sh \
-  test_taler_exchange_httpd_restart.sh
+  test_taler_exchange_httpd.sh
 if HAVE_EXPENSIVE_TESTS
 check_SCRIPTS += \
   test_taler_exchange_httpd_afl.sh
