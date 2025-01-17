{
  lib,
  stdenv,
  fetchurl,
  libxml2,
  openssl,
  bzip2,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "dclib";
  version = "0.3.7";

  src = fetchurl {
    url = "ftp://ftp.debian.nl/pub/freebsd/ports/distfiles/dclib-${version}.tar.bz2";
    sha256 = "02jdzm5hqzs1dv2rd596vgpcjaapm55pqqapz5m94l30v4q72rfc";
  };

  buildInputs = [
    libxml2
    openssl
    bzip2
    zlib
  ];

  meta = with lib; {
    description = "Peer-to-Peer file sharing client";
    homepage = "http://dcgui.berlios.de";
    platforms = platforms.linux;
    license = [
      licenses.openssl
      licenses.gpl2
    ];
  };
}
