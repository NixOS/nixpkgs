{ stdenv, lib, unzip, autoPatchelfHook
, fetchurl, atomEnv, makeWrapper
, makeDesktopItem, copyDesktopItems, wrapGAppsHook, libxshmfence
, metaCommon
}:

let
  pname = "trilium-desktop";
  version = "0.60.4";

  linuxSource.url = "https://github.com/zadam/trilium/releases/download/v${version}/trilium-linux-x64-${version}.tar.xz";
  linuxSource.sha256 = "02vbghvi2sbh943rslgm712x9zccvpjab3jvr5b1bw4bq5fzppgq";

  darwinSource.url = "https://github.com/zadam/trilium/releases/download/v${version}/trilium-mac-x64-${version}.zip";
  darwinSource.sha256 = "0z6dk16xdzkiyxrm1yh3iz5351c8sdzvk8v5l3jdqy7davxw9f86";

  meta = metaCommon // {
    mainProgram = "trilium";
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };

  linux = stdenv.mkDerivation rec {
    inherit pname version meta;

    src = fetchurl linuxSource;

    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
      wrapGAppsHook
      copyDesktopItems
    ];

    buildInputs = atomEnv.packages ++ [ libxshmfence ];

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
    preFixup = ''
      gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : ${atomEnv.libPath})
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
