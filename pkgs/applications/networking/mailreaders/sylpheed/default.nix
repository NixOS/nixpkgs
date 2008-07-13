{ sslSupport ? true
, gpgSupport ? false
, stdenv, fetchurl, pkgconfig, gtk
, openssl ? null
, gpgme ? null
}:

assert sslSupport -> openssl != null;
assert gpgSupport -> gpgme != null;

stdenv.mkDerivation {
  name = "sylpheed-2.5.0";

  src = fetchurl {
    url = http://sylpheed.sraoss.jp/sylpheed/v2.5/sylpheed-2.5.0.tar.bz2;
    sha256 = "0qc7sgcb23x16y6qhyrbv3hphqkmk5s9nr6xfxv5rqi6272qv2ni";
  };

  buildInputs = [
    pkgconfig gtk
    (if sslSupport then openssl else null)
    (if gpgSupport then gpgme else null)
  ];

  configureFlags = [
    (if sslSupport then "--enable-ssl" else null)
  ];

}
