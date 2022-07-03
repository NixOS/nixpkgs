{ dpkg, fetchurl, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "chromium-codecs-ffmpeg-extra";
  version = "102.0.5005.49";

  src = fetchurl {
    url = "https://launchpadlibrarian.net/601067148/${pname}_${version}-0ubuntu0.18.04.1_amd64.deb";
    sha256 = "sha256-b0oTDOi9VY+8v4JUAGkqdcum4uis08/v+COTx8eHBXg=";
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
