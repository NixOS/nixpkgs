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
  name = "subversion-1.0.9";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://subversion.tigris.org/tarballs/subversion-1.0.9.tar.bz2;
    md5 = "d6b4c240f5e2a589a694e64e4ad27feb";
  };

  openssl = if sslSupport then openssl else null;
  httpd = if httpServer then httpd else null;
  db4 = if localServer then db4 else null;
  swig = if swigBindings then swig else null;
  python = if swigBindings then swig.python else null;

  inherit expat localServer httpServer sslSupport swigBindings;
}
