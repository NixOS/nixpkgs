{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

let
  bits = if stdenv.hostPlatform.is64bit then "x64" else "ia32";
  version = "0.98.0";
in
stdenv.mkDerivation {
  pname = "nwjs-ffmpeg-prebuilt";
  inherit version;

  src =
    let
      hashes = {
        "x64" = "sha256-rlVS7R53ejshg0dh7swuLC/KRc83sPgYK3Av6VCEkiI=";
        "ia32" = "sha256-rlVS7R53ejshg0dh7swuLC/KRc83sPgYK3Av6VCEkiI=";
      };
    in
    fetchurl {
      url = "https://github.com/nwjs-ffmpeg-prebuilt/nwjs-ffmpeg-prebuilt/releases/download/${version}/${version}-linux-${bits}.zip";
      hash = hashes.${bits};
    };
  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -R libffmpeg.so $out/lib/

    runHook postInstall
  '';

  meta = {
    description = "An app runtime based on Chromium and node.js";
    homepage = "https://nwjs.io/";
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [
      ilya-epifanov
      mikaelfangel
    ];
    license = lib.licenses.gpl2Plus;
  };
}
