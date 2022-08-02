{ lib, stdenv, nixosTests, fetchurl, autoPatchelfHook, atomEnv, makeWrapper, makeDesktopItem, copyDesktopItems, libxshmfence, wrapGAppsHook }:

let
  metaCommon = with lib; {
    description = "Hierarchical note taking application with focus on building large personal knowledge bases";
    homepage = "https://github.com/zadam/trilium";
    license = licenses.agpl3Plus;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ fliegendewurst ];
  };

  version = "0.53.2";

  desktopSource.url = "https://github.com/zadam/trilium/releases/download/v${version}/trilium-linux-x64-${version}.tar.xz";
  desktopSource.sha256 = "0sjljyn7x0kv1692wccdjsll8h49r9lyqbrfnz4cn147xinclyw4";

  serverSource.url = "https://github.com/zadam/trilium/releases/download/v${version}/trilium-linux-x64-server-${version}.tar.xz";
  serverSource.sha256 = "0y5xjf4r0c2hw2ch4ml55fq1nlmgnakq4zh3ch8sdgzm86nchavb";

in {

  trilium-desktop = stdenv.mkDerivation rec {
    pname = "trilium-desktop";
    inherit version;
    meta = metaCommon // {
      mainProgram = "trilium";
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


  trilium-server = stdenv.mkDerivation rec {
    pname = "trilium-server";
    inherit version;
    meta = metaCommon;

    src = fetchurl serverSource;

    nativeBuildInputs = [
      autoPatchelfHook
    ];

    buildInputs = [
      stdenv.cc.cc.lib
    ];

    patches = [
      # patch logger to use console instead of rolling files
      ./0001-Use-console-logger-instead-of-rolling-files.patch
    ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      mkdir -p $out/share/trilium-server

      cp -r ./* $out/share/trilium-server
      runHook postInstall
    '';

    postFixup = ''
      cat > $out/bin/trilium-server <<EOF
      #!${stdenv.cc.shell}
      cd $out/share/trilium-server
      exec ./node/bin/node src/www
      EOF
      chmod a+x $out/bin/trilium-server
    '';

    passthru.tests = {
      trilium-server = nixosTests.trilium-server;
    };
  };
}
