{ stdenv, fetchurl, pkgconfig, gtk2, openssl ? null, gpgme ? null
, gpgSupport ? true, sslSupport ? true }:

assert gpgSupport -> gpgme != null;
assert sslSupport -> openssl != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "sylpheed-${version}";
  version = "3.6.0";

  src = fetchurl {
    url = "http://sylpheed.sraoss.jp/sylpheed/v3.6/${name}.tar.bz2";
    sha256 = "0idk9nz3d200l2bxc38vnxlx0wcslrvncy9lk50vz7dl8c5sg97b";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ gtk2 ]
    ++ optionals gpgSupport [ gpgme ]
    ++ optionals sslSupport [ openssl ];

  configureFlags = [
    (optional gpgSupport "--enable-gpgme")
    (optional sslSupport "--enable-ssl")
  ];

  meta = {
    homepage = http://sylpheed.sraoss.jp/en/;
    description = "Lightweight and user-friendly e-mail client";
    maintainers = with maintainers; [ eelco ];
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.gpl2;
  };
}
