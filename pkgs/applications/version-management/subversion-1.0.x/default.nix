{ localServer ? false
, httpServer ? false
, sslSupport ? false
, swigBindings ? false
, stdenv, fetchurl
, openssl ? null, httpd ? null, db4 ? null, expat, swig ? null
}:

assert expat != null;
assert localServer -> db4 != null;
assert httpServer -> httpd != null && httpd.expat == expat;
assert sslSupport -> openssl != null && (httpServer -> httpd.openssl == openssl);
assert swigBindings -> swig != null && swig.pythonSupport;

stdenv.mkDerivation {
  name = "subversion-1.0.8";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://subversion.tigris.org/tarballs/subversion-1.0.8.tar.bz2;
    md5 = "b2378b7d9d00653249877531a61ef1db";
  };

  openssl = if sslSupport then openssl else null;
  httpd = if httpServer then httpd else null;
  db4 = if localServer then db4 else null;
  swig = if swigBindings then swig else null;
  python = if swigBindings then swig.python else null;

  inherit expat localServer httpServer sslSupport swigBindings;
}
