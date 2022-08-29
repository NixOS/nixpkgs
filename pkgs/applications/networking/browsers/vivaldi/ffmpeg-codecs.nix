{ dpkg, fetchurl, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "chromium-codecs-ffmpeg-extra";
  version = "104.0.5112.79";

  src = fetchurl {
    url = "https://launchpadlibrarian.net/616178945/${pname}_${version}-0ubuntu0.18.04.1_amd64.deb";
    sha256 = "sha256-JL14+2TsX1qXfRpA/tAADC0iujPj37ld6T9yPUD8R38=";
  };

  buildInputs = [ dpkg ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    install -vD usr/lib/chromium-browser/libffmpeg.so $out/lib/libffmpeg.so
  '';

  meta = with lib; {
    description = "Additional support for proprietary codecs for Vivaldi";
    homepage    = "https://ffmpeg.org/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license     = licenses.lgpl21;
    maintainers = with maintainers; [ betaboon cawilliamson lluchs ];
    platforms   = [ "x86_64-linux" ];
  };
}
