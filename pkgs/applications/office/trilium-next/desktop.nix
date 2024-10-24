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
  version,
}:

let
  pname = "trilium-next-desktop";
  inherit version;

  linuxSource.url = "https://github.com/TriliumNext/Notes/releases/download/v${version}/trilium-linux-x64-${version}.tar.xz";
  linuxSource.sha256 = "034cqj0g33kkyprkh1gzk0ba4h8j8lw2l4l0jbhv4z9gr21d3va6";

  darwinSource.url = "https://github.com/TriliumNext/Notes/releases/download/v${version}/trilium-mac-x64-${version}.zip";
  darwinSource.sha256 = "1n0zjbm21ab13ij1rpi6fp854vis78cw3j8zhz39kcbidb5k429d";

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
        desktopName = "TriliumNext Notes";
        categories = [ "Office" ];
        startupWMClass = "trilium notes next";
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
if stdenv.isDarwin then darwin else linux
