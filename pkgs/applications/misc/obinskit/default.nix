{ lib
, stdenv
, fetchurl
, xorg
, libxkbcommon
, systemd
, gcc-unwrapped
, electron_3
, wrapGAppsHook
, makeDesktopItem
}:

let
  libPath = lib.makeLibraryPath [
    libxkbcommon
    xorg.libXt
    systemd.lib
    stdenv.cc.cc.lib
  ];

  desktopItem = makeDesktopItem rec {
    name = "Obinskit";
    exec = "obinskit";
    icon = "obinskit.png";
    desktopName = "Obinskit";
    genericName = "Obinskit keyboard configurator";
    categories = "Utility";
  };

in stdenv.mkDerivation rec {
  pname = "obinskit";
  version = "1.1.1";

  src = fetchurl {
    url = "http://releases.obins.net/occ/linux/tar/ObinsKit_${version}_x64.tar.gz";
    sha256 = "0052m4msslc4k9g3i5vl933cz5q2n1affxhnm433w4apajr8h28h";
  };

  unpackPhase = "tar -xzf $src";

  sourceRoot = "ObinsKit_${version}_x64";

  nativeBuildInputs = [ wrapGAppsHook ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/opt/obinskit
    install icudtl.dat $out/opt/obinskit/
    install natives_blob.bin $out/opt/obinskit/
    install v8_context_snapshot.bin $out/opt/obinskit/
    install blink_image_resources_200_percent.pak $out/opt/obinskit/
    install content_resources_200_percent.pak $out/opt/obinskit/
    install content_shell.pak $out/opt/obinskit/
    install ui_resources_200_percent.pak $out/opt/obinskit/
    install views_resources_200_percent.pak $out/opt/obinskit/
    cp -r resources $out/opt/obinskit/
    cp -r locales $out/opt/obinskit/

    mkdir -p $out/bin
    ln -s ${electron_3}/bin/electron $out/bin/obinskit

    mkdir -p $out/share/{applications,pixmaps}
    install resources/icons/tray-darwin@2x.png $out/share/pixmaps/obinskit.png
    ln -s ${desktopItem}/share/applications/* $out/share/applications
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --add-flags $out/opt/obinskit/resources/app.asar
      --prefix LD_LIBRARY_PATH : "${libPath}"
    )
  '';

  meta = with lib; {
    description = "Graphical configurator for Anne Pro and Anne Pro II keyboards";
    homepage = "http://en.obins.net/obinskit/";
    license = licenses.unfree;
    maintainers = [ maintainers.shou ];
    platforms = [ "x86_64-linux" ];
  };
}
