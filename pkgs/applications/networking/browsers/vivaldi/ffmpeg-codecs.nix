{ dpkg, fetchurl, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "chromium-codecs-ffmpeg-extra";
  version = "103.0.5060.53";

  src = fetchurl {
    url = "https://launchpadlibrarian.net/607589056/${pname}_${version}-0ubuntu0.18.04.1_amd64.deb";
    sha256 = "sha256-Tsp5Y6sCn+mKrLGZSAWGFoSTHiyfANQ5VA7pesU1HyU=";
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
