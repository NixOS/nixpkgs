{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  glib,
  libGL,
  libgbm,
  libva,
}:

let
  version = "0.1.9"; # pinned in mpv-prism.lock.json at repo root, bump alongside seanime

  sources = {
    x86_64-linux = fetchzip {
      url = "https://seanime.app/assets/mpv-prism/${version}/native/linux-x64.tar.gz";
      hash = "sha256-jYFTXI03VBBGGk/bRVOYYBazFZYyifKtOZdW1Xs+Ubk=";
      stripRoot = false;
    };
    aarch64-darwin = fetchzip {
      url = "https://seanime.app/assets/mpv-prism/${version}/native/darwin-arm64.tar.gz";
      hash = "sha256-ftD1RLTmGRpqZk54d7162d4eMGGD1YbmRgoNQRka/YY=";
      stripRoot = false;
    };
  };
in
stdenv.mkDerivation {
  pname = "mpv-prism-electron-native";
  inherit version;

  src =
    sources.${stdenv.hostPlatform.system}
      or (throw "mpv-prism: unsupported system ${stdenv.hostPlatform.system}");

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc.lib
    glib
    libGL
    libgbm
    libva
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r . "$out/"
    runHook postInstall
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    rm -f "$out"/{libglib-2.0.so.0,libEGL.so.1,libGLESv2.so.2,libgbm.so.1,libva.so.2,libva-drm.so.2,libva-x11.so.2}
  '';

  meta = {
    description = "Prebuilt libmpv native module for Seanime's mpv-prism player";
    homepage = "https://seanime.app";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
  };
}
