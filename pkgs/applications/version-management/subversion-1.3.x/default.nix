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
  name = "subversion-1.3.0";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://subversion.tigris.org/downloads/subversion-1.3.0.tar.gz;
    sha1 = "98cb017844750d4ed26e2a811c581a644e3ad585";
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
