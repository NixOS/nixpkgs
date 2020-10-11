{ stdenv, nixosTests, fetchurl, autoPatchelfHook, atomEnv, makeWrapper, makeDesktopItem, gtk3, wrapGAppsHook, zlib, libxkbfile }:

let
  description = "Trilium Notes is a hierarchical note taking application with focus on building large personal knowledge bases";
  desktopItem = makeDesktopItem {
    name = "Trilium";
    exec = "trilium";
    icon = "trilium";
    comment = description;
    desktopName = "Trilium Notes";
    categories = "Office";
  };

  meta = with stdenv.lib; {
    inherit description;
    homepage = "https://github.com/zadam/trilium";
    license = licenses.agpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ emmanuelrosa dtzWill kampka ];
  };

  version = "0.43.3";

  desktopSource = {
    url = "https://github.com/zadam/trilium/releases/download/v${version}/trilium-linux-x64-${version}.tar.xz";
    sha256 = "1k9vcs7pwa89bzivqp0gfs45jzqw216fpypg3ja4n2dzn4qkv2as";
  };

  serverSource = {
    url = "https://github.com/zadam/trilium/releases/download/v${version}/trilium-linux-x64-server-${version}.tar.xz";
    sha256 = "1n3v7wdav6mvgcy72mmfhncsa74i0ax1ij5rjczgfjjyiyc5y0rk";
  };

in {

  trilium-desktop = stdenv.mkDerivation rec {
    pname = "trilium-desktop";
    inherit version;
    inherit meta;

    src = fetchurl desktopSource;

    # Fetch from source repo, no longer included in release.
    # (they did special-case icon.png but we want the scalable svg)
    # Use the version here to ensure we get any changes.
    trilium_svg = fetchurl {
      url = "https://raw.githubusercontent.com/zadam/trilium/v${version}/images/trilium.svg";
      sha256 = "1rgj7pza20yndfp8n12k93jyprym02hqah36fkk2b3if3kcmwnfg";
    };


    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
      wrapGAppsHook
    ];

    buildInputs = atomEnv.packages ++ [ gtk3 ];

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/share/trilium
      mkdir -p $out/share/{applications,icons/hicolor/scalable/apps}

      cp -r ./* $out/share/trilium
      ln -s $out/share/trilium/trilium $out/bin/trilium

      ln -s ${trilium_svg} $out/share/icons/hicolor/scalable/apps/trilium.svg
      cp ${desktopItem}/share/applications/* $out/share/applications
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
      zlib
      libxkbfile
    ];

    patches = [ ./0001-Use-console-logger-instead-of-rolling-files.patch ] ;
    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/share/trilium-server

      cp -r ./* $out/share/trilium-server
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
