{ localServer ? false
, httpServer ? false
, sslSupport ? false
, compressionSupport ? false
, pythonBindings ? false
, javahlBindings ? false
, stdenv, fetchurl
, openssl ? null, httpd ? null, db4 ? null, expat, swig ? null, jdk ? null, zlib ? null
}:

assert expat != null;
assert localServer -> db4 != null;
assert httpServer -> httpd != null && httpd.expat == expat;
assert sslSupport -> openssl != null && (httpServer -> httpd.openssl == openssl);
assert pythonBindings -> swig != null && swig.pythonSupport;
assert javahlBindings -> jdk != null;
assert compressionSupport -> zlib != null;

stdenv.mkDerivation {
  name = "subversion-1.2.3";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/subversion-1.2.3.tar.bz2;
    md5 = "a14bc6590241b6e5c2ff2b354cc184a1";
  };

  openssl = if sslSupport then openssl else null;
  zlib = if compressionSupport then zlib else null;
  httpd = if httpServer then httpd else null;
  db4 = if localServer then db4 else null;
  swig = if pythonBindings then swig else null;
  python = if pythonBindings then swig.python else null;
  jdk = if javahlBindings then jdk else null;

  inherit expat localServer httpServer sslSupport
          pythonBindings javahlBindings;
}
