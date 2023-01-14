{ stdenv, lib,
autoPatchelfHook, fetchurl, atomEnv, makeWrapper,
makeDesktopItem, copyDesktopItems, wrapGAppsHook,
libxshmfence
}:

let
  desktopSource.url = "https://github.com/zadam/trilium/releases/download/v${version}/trilium-linux-x64-${version}.tar.xz";
  desktopSource.sha256 = "1xr8fx5m6p9z18al1iigf45acn7b69vhbc6z6q1v933bvkwry16c";
  version = "0.58.7";
in stdenv.mkDerivation rec {
  pname = "trilium-desktop";
  inherit version;
  meta = with lib; {
    mainProgram = "trilium";
    description = "Hierarchical note taking application with focus on building large personal knowledge bases";
    homepage = "https://github.com/zadam/trilium";
    license = licenses.agpl3Plus;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ fliegendewurst ];
  };

  src = fetchurl desktopSource;

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
}
