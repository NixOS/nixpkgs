<<<<<<< HEAD
{ squashfsTools, fetchurl, lib, stdenv }:

# This derivation roughly follows the update-ffmpeg script that ships with the official Vivaldi
# downloads at https://vivaldi.com/download/
stdenv.mkDerivation rec {
  pname = "chromium-codecs-ffmpeg-extra";
  version = "111306";

  src = fetchurl {
    url = "https://api.snapcraft.io/api/v1/snaps/download/XXzVIXswXKHqlUATPqGCj2w2l7BxosS8_34.snap";
    sha256 = "sha256-Dna9yFgP7JeQLAeZWvSZ+eSMX2yQbX2/+mX0QC22lYY=";
  };

  buildInputs = [ squashfsTools ];

  unpackPhase = ''
    unsquashfs -dest . $src
  '';

  installPhase = ''
    install -vD chromium-ffmpeg-${version}/chromium-ffmpeg/libffmpeg.so $out/lib/libffmpeg.so
=======
{ dpkg, fetchurl, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "chromium-codecs-ffmpeg-extra";
  version = "104.0.5112.101";

  src = fetchurl {
    url = "https://launchpadlibrarian.net/618703258/${pname}_${version}-0ubuntu0.18.04.1_amd64.deb";
    sha256 = "sha256-V+zqLhI8L/8ssxSR6S2v4gUAtoK3fB8Fi9bajBFEauU=";
  };

  buildInputs = [ dpkg ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    install -vD usr/lib/chromium-browser/libffmpeg.so $out/lib/libffmpeg.so
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    description = "Additional support for proprietary codecs for Vivaldi";
    homepage    = "https://ffmpeg.org/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license     = licenses.lgpl21;
<<<<<<< HEAD
    maintainers = with maintainers; [ betaboon cawilliamson fptje ];
=======
    maintainers = with maintainers; [ betaboon cawilliamson lluchs ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms   = [ "x86_64-linux" ];
  };
}
