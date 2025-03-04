{
  lib,
  stdenv,
  fetchurl,
  libowfat,
  libcap,
  zlib,
  openssl,
  libxcrypt,
}:

let
  version = "0.16";
in
stdenv.mkDerivation rec {
  pname = "gatling";
  inherit version;

  src = fetchurl {
    url = "https://www.fefe.de/gatling/${pname}-${version}.tar.xz";
    sha256 = "0nrnws5qrl4frqcsfa9z973vv5mifgr9z170qbvg3mq1wa7475jz";
  };

  buildInputs = [
    libowfat
    libcap
    zlib
    openssl
    libxcrypt
  ];

  configurePhase = ''
    substituteInPlace Makefile --replace "/usr/local" "$out"
    substituteInPlace GNUmakefile --replace "/opt/diet" "$out"
  '';

  buildPhase = ''
    make gatling
  '';

  meta = with lib; {
    description = "High performance web server";
    homepage = "http://www.fefe.de/gatling/";
    license = lib.licenses.gpl2Only;
    platforms = platforms.linux;
  };
}
