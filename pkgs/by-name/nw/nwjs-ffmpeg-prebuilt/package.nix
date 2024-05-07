{ fetchurl
, unzip
, lib
, tree
, stdenv
}:

let
  bits = if stdenv.is64bit then "x64" else "ia32";
  version = "0.87.0";
in
stdenv.mkDerivation {
  pname = "nwjs-ffmpeg-prebuilt";
  inherit version;

  src =
    let
      hashes = {
        "x64" = "sha256-4NYEoxm3TIZK1I1jKtMgqV+bO1tQ+dGEMfGDB/Egiio=";
        "ia32" = "sha256-4NYEoxm3TIZK1I1jKtMgqV+bO1tQ+dGEMfGDB/Egiio=";
      };
    in
    fetchurl {
      url = "https://github.com/nwjs-ffmpeg-prebuilt/nwjs-ffmpeg-prebuilt/releases/download/${version}/${version}-linux-${bits}.zip";
      hash = hashes.${bits};
    };
  sourceRoot = ".";

  nativeBuildInputs = [
    unzip
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -R libffmpeg.so $out/lib/

    runHook postInstall
  '';

  meta = {
    description = "An app runtime based on Chromium and node.js";
    homepage = "https://nwjs.io/";
    platforms = [ "i686-linux" "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ ilya-epifanov mikaelfangel ];
    license = lib.licenses.gpl2Plus;
  };
}
