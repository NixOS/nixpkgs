{ localServer ? false
, httpServer ? false
, sslSupport ? false
, swigBindings ? false
, stdenv, fetchurl
, openssl ? null, httpd ? null, db4 ? null, expat, swig ? null
}:

assert !isNull expat;
assert localServer -> !isNull db4;
assert httpServer -> !isNull httpd && httpd.expat == expat;
assert sslSupport -> !isNull openssl && (httpServer -> httpd.openssl == openssl);
assert swigBindings -> !isNull swig && swig.pythonSupport;

derivation {
  name = "subversion-0.37.0";
  system = stdenv.system;

  builder = ./builder.sh;
  src = fetchurl {
    url = http://subversion.tigris.org/tarballs/subversion-0.37.0.tar.gz;
    md5 = "048c4d17d5880dc8f3699020eac56224";
  };

  localServer = localServer;
  httpServer = httpServer;
  sslSupport = sslSupport;
  swigBindings = swigBindings;

  stdenv = stdenv;
  openssl = if sslSupport then openssl else null;
  httpd = if httpServer then httpd else null;
  expat = expat;
  db4 = if localServer then db4 else null;
  swig = if swigBindings then swig else null;
  python = if swigBindings then swig.python else null;
}
