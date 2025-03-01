{
  squashfsTools,
  fetchurl,
  lib,
  stdenv,
}:

# This derivation roughly follows the update-ffmpeg script that ships with the official Vivaldi
# downloads at https://vivaldi.com/download/
stdenv.mkDerivation rec {
  pname = "chromium-codecs-ffmpeg-extra";
  version = "115541";

  src = fetchurl {
    url = "https://api.snapcraft.io/api/v1/snaps/download/XXzVIXswXKHqlUATPqGCj2w2l7BxosS8_41.snap";
    hash = "sha256-a1peHhku+OaGvPyChvLdh6/7zT+v8OHNwt60QUq7VvU=";
  };

  buildInputs = [ squashfsTools ];

  unpackPhase = ''
    unsquashfs -dest . $src
  '';

  installPhase = ''
    install -vD chromium-ffmpeg-${version}/chromium-ffmpeg/libffmpeg.so $out/lib/libffmpeg.so
  '';

  meta = with lib; {
    description = "Additional support for proprietary codecs for Vivaldi";
    homepage = "https://ffmpeg.org/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.lgpl21;
    maintainers = with maintainers; [
      betaboon
      cawilliamson
      fptje
    ];
    platforms = [ "x86_64-linux" ];
  };
}
