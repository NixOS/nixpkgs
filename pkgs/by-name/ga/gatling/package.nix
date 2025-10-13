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
    runHook preConfigure

    substituteInPlace Makefile --replace-fail "/usr/local" "$out"
    substituteInPlace GNUmakefile --replace-fail "/opt/diet" "$out"
    substituteInPlace tryalloca.c --replace-fail "main() {" "int main() {"
    substituteInPlace trysocket.c --replace-fail "main() {" "int main() {"

    runHook postConfigure
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
