{ lib, stdenv, nixosTests, fetchurl, autoPatchelfHook, atomEnv, makeWrapper, makeDesktopItem, gtk3, libxshmfence, wrapGAppsHook }:

let
  description = "Trilium Notes is a hierarchical note taking application with focus on building large personal knowledge bases";
  desktopItem = makeDesktopItem {
    name = "Trilium";
    exec = "trilium";
    icon = "trilium";
    comment = description;
    desktopName = "Trilium Notes";
    categories = [ "Office" ];
  };

  meta = with lib; {
    inherit description;
    homepage = "https://github.com/zadam/trilium";
    license = licenses.agpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ fliegendewurst ];
  };

  version = "0.50.3";

  desktopSource = {
    url = "https://github.com/zadam/trilium/releases/download/v${version}/trilium-linux-x64-${version}.tar.xz";
    sha256 = "sha256-0N2+NcdZGxaj4LcG5edyd3ry+0dSQSfUQRqZEYFfWqQ=";
  };

  serverSource = {
    url = "https://github.com/zadam/trilium/releases/download/v${version}/trilium-linux-x64-server-${version}.tar.xz";
    sha256 = "sha256-za32yRhusReoGIRdbfx30CPH63BVXz2Z7jkhxtb7XSo=";
  };

in {

  trilium-desktop = stdenv.mkDerivation rec {
    pname = "trilium-desktop";
    inherit version;
    inherit meta;

    src = fetchurl desktopSource;

    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
      wrapGAppsHook
    ];

    buildInputs = atomEnv.packages ++ [ gtk3 libxshmfence ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      mkdir -p $out/share/trilium
      mkdir -p $out/share/{applications,icons/hicolor/128x128/apps}

      cp -r ./* $out/share/trilium
      ln -s $out/share/trilium/trilium $out/bin/trilium

      ln -s $out/share/trilium/icon.png $out/share/icons/hicolor/128x128/apps/trilium.png
      cp ${desktopItem}/share/applications/* $out/share/applications
      runHook postInstall
    '';

    # LD_LIBRARY_PATH "shouldn't" be needed, remove when possible :)
    preFixup = ''
      gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : ${atomEnv.libPath})
    '';

    dontStrip = true;
  };


  trilium-server = stdenv.mkDerivation rec {
    pname = "trilium-server";
    inherit version;
    inherit meta;

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
