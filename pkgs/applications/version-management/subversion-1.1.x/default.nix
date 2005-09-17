{ localServer ? false
, httpServer ? false
, sslSupport ? false
, compressionSupport ? false
, pythonBindings ? false
, javaSwigBindings ? false
, javahlBindings ? false
, stdenv, fetchurl
, openssl ? null, httpd ? null, db4 ? null, expat, swig ? null, jdk ? null, zlib ? null
}:

assert expat != null;
assert localServer -> db4 != null;
assert httpServer -> httpd != null && httpd.expat == expat;
assert sslSupport -> openssl != null && (httpServer -> httpd.openssl == openssl);
assert pythonBindings -> swig != null && swig.pythonSupport;
assert javaSwigBindings -> swig != null && swig.javaSupport;
assert javahlBindings -> jdk != null;
assert compressionSupport -> zlib != null;

stdenv.mkDerivation {
  name = "subversion-1.1.4";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/subversion-1.1.4.tar.bz2;
    md5 = "6e557ae65b6b8d7577cc7704ede85a23";
  };

  # This is a hopefully temporary fix for the problem that
  # libsvnjavahl.so isn't linked against libstdc++, which causes
  # loading the library into the JVM to fail.
  patches = if javahlBindings then [./javahl.patch] else [];

  openssl = if sslSupport then openssl else null;
  zlib = if compressionSupport then zlib else null;
  httpd = if httpServer then httpd else null;
  db4 = if localServer then db4 else null;
  swig = if pythonBindings || javaSwigBindings then swig else null;
  python = if pythonBindings then swig.python else null;
  jdk = if javaSwigBindings then swig.jdk else
          if javahlBindings then jdk else null;

  inherit expat localServer httpServer sslSupport
          pythonBindings javaSwigBindings javahlBindings;
}
