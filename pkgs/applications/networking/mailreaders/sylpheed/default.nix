{ sslSupport ? true
, gpgSupport ? false
, stdenv, fetchurl, pkgconfig, gtk
, openssl ? null
, gpgme ? null
}:

assert sslSupport -> openssl != null;
assert gpgSupport -> gpgme != null;

stdenv.mkDerivation {
  name = "sylpheed-2.4.1";

  src = fetchurl {
    url = http://sylpheed.sraoss.jp/sylpheed/v2.4/sylpheed-2.4.1.tar.bz2;
    sha256 = "1hmia3lnh7yr2ca8bgxzn311waxfs0rhk0psck3dcjfhzxzp72zj";
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
