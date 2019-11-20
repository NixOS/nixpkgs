{ stdenv, fetchurl, pkgconfig, gtk2, openssl ? null, gpgme ? null
, gpgSupport ? true, sslSupport ? true }:

assert gpgSupport -> gpgme != null;
assert sslSupport -> openssl != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "sylpheed";
  version = "3.7.0";

  src = fetchurl {
    url = "https://sylpheed.sraoss.jp/sylpheed/v3.7/${pname}-${version}.tar.xz";
    sha256 = "0j9y5vdzch251s264diw9clrn88dn20bqqkwfmis9l7m8vmwasqd";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ gtk2 ]
    ++ optionals gpgSupport [ gpgme ]
    ++ optionals sslSupport [ openssl ];

  configureFlags = optional gpgSupport "--enable-gpgme"
    ++ optional sslSupport "--enable-ssl";

  meta = {
    homepage = http://sylpheed.sraoss.jp/en/;
    description = "Lightweight and user-friendly e-mail client";
    maintainers = with maintainers; [ eelco ];
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.gpl2;
  };
}
