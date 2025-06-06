{
  lib,
  stdenv,
  fetchurl,
  boost,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "asio";
  version = "1.24.0";

  src = fetchurl {
    url = "mirror://sourceforge/asio/asio-${version}.tar.bz2";
    hash = "sha256-iXaBLCShGGAPb88HGiBgZjCmmv5MCr7jsN6lKOaCxYU=";
  };

  propagatedBuildInputs = [ boost ];

  buildInputs = [ openssl ];

  meta = with lib; {
    homepage = "http://asio.sourceforge.net/";
    description = "Cross-platform C++ library for network and low-level I/O programming";
    license = licenses.boost;
    broken = stdenv.hostPlatform.isDarwin && lib.versionOlder version "1.16.1";
    platforms = platforms.unix;
  };
}
