{ localServer ? false
, httpServer ? false
, sslSupport ? false
, pythonBindings ? false
, javaSwigBindings ? false
, javahlBindings ? false
, stdenv, fetchurl
, openssl ? null, httpd ? null, db4 ? null, expat, swig ? null, j2sdk ? null
}:

assert expat != null;
assert localServer -> db4 != null;
assert httpServer -> httpd != null && httpd.expat == expat;
assert sslSupport -> openssl != null && (httpServer -> httpd.openssl == openssl);
assert pythonBindings -> swig != null && swig.pythonSupport;
assert javaSwigBindings -> swig != null && swig.javaSupport;
assert javahlBindings -> j2sdk != null;

stdenv.mkDerivation {
  name = "subversion-1.1.1";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://subversion.tigris.org/tarballs/subversion-1.1.1.tar.bz2;
    md5 = "a180c3fe91680389c210c99def54d9e0";
  };

  # This is a hopefully temporary fix for the problem that
  # libsvnjavahl.so isn't linked against libstdc++, which causes
  # loading the library into the JVM to fail.
  patches = if javahlBindings then [./javahl.patch] else [];

  openssl = if sslSupport then openssl else null;
  httpd = if httpServer then httpd else null;
  db4 = if localServer then db4 else null;
  swig = if pythonBindings || javaSwigBindings then swig else null;
  python = if pythonBindings then swig.python else null;
  j2sdk = if javaSwigBindings then swig.j2sdk else
          if javahlBindings then j2sdk else null;

  inherit expat localServer httpServer sslSupport
          pythonBindings javaSwigBindings javahlBindings;
}
