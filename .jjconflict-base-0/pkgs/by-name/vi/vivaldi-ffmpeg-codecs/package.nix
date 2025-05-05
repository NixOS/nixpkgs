{
  fetchurl,
  lib,
  squashfsTools,
  stdenv,
}:

# This derivation roughly follows the update-ffmpeg script that ships with the official Vivaldi
# downloads at https://vivaldi.com/download/

let
  sources = {
    x86_64-linux = fetchurl {
      url = "https://api.snapcraft.io/api/v1/snaps/download/XXzVIXswXKHqlUATPqGCj2w2l7BxosS8_73.snap";
      hash = "sha256-YsAYQ/fKlrvu7IbIxLO0oVhWOtZZzUmA00lrU+z/0+s=";
    };
    aarch64-linux = fetchurl {
      url = "https://api.snapcraft.io/api/v1/snaps/download/XXzVIXswXKHqlUATPqGCj2w2l7BxosS8_74.snap";
      hash = "sha256-zwCbaFeVmeHQLEp7nmD8VlEjSY9PqSVt6CdW4wPtw9o=";
    };
  };
in
stdenv.mkDerivation rec {

  pname = "chromium-codecs-ffmpeg-extra";

  version = "119293";

  src = sources."${stdenv.hostPlatform.system}";

  buildInputs = [ squashfsTools ];

  unpackPhase = ''
    unsquashfs -dest . $src
  '';

  installPhase = ''
    install -vD chromium-ffmpeg-${version}/chromium-ffmpeg/libffmpeg.so $out/lib/libffmpeg.so
  '';

  passthru = {
    inherit sources;
    updateScript = ./update.sh;
  };

  meta = with lib; {
    description = "Additional support for proprietary codecs for Vivaldi and other chromium based tools";
    homepage = "https://ffmpeg.org/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.lgpl21;
    maintainers = with maintainers; [
      betaboon
      cawilliamson
      fptje
      sarahec
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
