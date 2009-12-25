{ sslSupport ? true
, gpgSupport ? false
, stdenv, fetchurl, pkgconfig, gtk
, openssl ? null
, gpgme ? null
}:

assert sslSupport -> openssl != null;
assert gpgSupport -> gpgme != null;

stdenv.mkDerivation {
  name = "sylpheed-2.7.1";

  src = fetchurl {
    url = http://sylpheed.sraoss.jp/sylpheed/v2.7/sylpheed-2.7.1.tar.bz2;
    sha256 = "08sfz159y8hi3lky98m6p4nkfiima749lza8gf3s3vp2niylbdlb";
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
