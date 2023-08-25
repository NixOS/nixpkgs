{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "harsh";
  version = "0.8.28";

  src = fetchurl {
    url = "https://github.com/wakatara/harsh/releases/download/v${version}/harsh_Linux_x86_64.tar.gz";
    sha256 = "0ydz8srxyca1g2wrbvskx69s874rksn2nh4rj54s4xvd5pblyiqq";
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    tar -xf ${src} -C ./
    mkdir -p $out/bin/
    cp harsh $out/bin/
  '';

  meta = with lib; {
    homepage = "https://github.com/wakatara/harsh";
    description = "CLI habit tracking for geeks";
    license = licenses.mit;
    maintainers = with maintainers; [ LAURAilway ];
    platforms = platforms.linux;
    mainProgram = "harsh";
  };
}
