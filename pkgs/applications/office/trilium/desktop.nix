{
  stdenv,
  lib,
  unzip,
  autoPatchelfHook,
  fetchurl,
  makeWrapper,
  alsa-lib,
  mesa,
  nss,
  nspr,
  systemd,
  makeDesktopItem,
  copyDesktopItems,
  wrapGAppsHook3,
  metaCommon,
}:

let
  pname = "trilium-desktop";
  version = "0.63.6";

  linuxSource.url = "https://github.com/zadam/trilium/releases/download/v${version}/trilium-linux-x64-${version}.tar.xz";
  linuxSource.sha256 = "12kgq5x4f93hxz057zqhz0x1y0rxfxh90fv9fjjs3jrnk0by7f33";

  darwinSource.url = "https://github.com/zadam/trilium/releases/download/v${version}/trilium-mac-x64-${version}.zip";
  darwinSource.sha256 = "0ry512cn622av3nm8rnma2yvqc71rpzax639872ivvc5vm4rsc30";

  meta = metaCommon // {
    mainProgram = "trilium";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
  };

  linux = stdenv.mkDerivation rec {
    inherit pname version meta;

    src = fetchurl linuxSource;

    # TODO: migrate off autoPatchelfHook and use nixpkgs' electron
    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
      wrapGAppsHook3
      copyDesktopItems
    ];

    buildInputs = [
      alsa-lib
      mesa
      nss
      nspr
      stdenv.cc.cc
      systemd
    ];

    desktopItems = [
      (makeDesktopItem {
        name = "Trilium";
        exec = "trilium";
        icon = "trilium";
        comment = meta.description;
        desktopName = "Trilium Notes";
        categories = [ "Office" ];
        startupWMClass = "trilium notes";
      })
    ];

    # Remove trilium-portable.sh, so trilium knows it is packaged making it stop auto generating a desktop item on launch
    postPatch = ''
      rm ./trilium-portable.sh
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      mkdir -p $out/share/trilium
      mkdir -p $out/share/icons/hicolor/128x128/apps

      cp -r ./* $out/share/trilium
      ln -s $out/share/trilium/trilium $out/bin/trilium

      ln -s $out/share/trilium/icon.png $out/share/icons/hicolor/128x128/apps/trilium.png
      runHook postInstall
    '';

    # LD_LIBRARY_PATH "shouldn't" be needed, remove when possible :)
    # Error: libstdc++.so.6: cannot open shared object file: No such file or directory
    preFixup = ''
      gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs})
    '';

    dontStrip = true;

    passthru.updateScript = ./update.sh;
  };

  darwin = stdenv.mkDerivation {
    inherit pname version meta;

    src = fetchurl darwinSource;
    nativeBuildInputs = [ unzip ];

    installPhase = ''
      mkdir -p $out/Applications
      cp -r *.app $out/Applications
    '';
  };

in
if stdenv.hostPlatform.isDarwin then darwin else linux
