{ sslSupport ? true
, gpgSupport ? false
, stdenv, fetchurl, pkgconfig, gtk
, openssl ? null
, gpgme ? null
}:

assert sslSupport -> openssl != null;
assert gpgSupport -> gpgme != null;

stdenv.mkDerivation {
  name = "sylpheed-2.4.8";

  src = fetchurl {
    url = http://sylpheed.sraoss.jp/sylpheed/v2.4/sylpheed-2.4.8.tar.bz2;
    sha256 = "0r4bfkyz39pj02rzn38ss10dhhhv93z1azlbbwdgbkjii3k760fc";
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
