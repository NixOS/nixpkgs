{ localServer ? false
, httpServer ? false
, sslSupport ? false
, pythonBindings ? false
, javaBindings ? false
, stdenv, fetchurl
, openssl ? null, httpd ? null, db4 ? null, expat, swig ? null
}:

assert expat != null;
assert localServer -> db4 != null;
assert httpServer -> httpd != null && httpd.expat == expat;
assert sslSupport -> openssl != null && (httpServer -> httpd.openssl == openssl);
assert pythonBindings -> swig != null && swig.pythonSupport;
assert javaBindings -> swig != null && swig.javaSupport;

stdenv.mkDerivation {
  name = "subversion-1.1.0";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://subversion.tigris.org/tarballs/subversion-1.1.0.tar.bz2;
    md5 = "a91b0d79b8c8ab8747587037c044c6c9";
  };

  # This is a hopefully temporary fix for the problem that
  # libsvnjavahl.so isn't linked against libstdc++, which causes
  # loading the library into the JVM to fail.
  patches = if javaBindings then [./javahl.patch] else [];

  openssl = if sslSupport then openssl else null;
  httpd = if httpServer then httpd else null;
  db4 = if localServer then db4 else null;
  swig = if pythonBindings || javaBindings then swig else null;
  python = if pythonBindings then swig.python else null;
  j2sdk = if javaBindings then swig.j2sdk else null;

  inherit expat localServer httpServer sslSupport
          pythonBindings javaBindings;
}
