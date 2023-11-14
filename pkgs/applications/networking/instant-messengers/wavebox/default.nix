{ alsa-lib
, autoPatchelfHook
, fetchurl
, gtk3
, gtk4
, libnotify
, makeDesktopItem
, makeWrapper
, mesa
, nss
, lib
, libdrm
, qt5
, stdenv
, udev
, xdg-utils
, xorg
}:

let
  version = "10.117.21-2";
  desktopItem = makeDesktopItem rec {
    name = "Wavebox";
    exec = "wavebox";
    icon = "wavebox";
    desktopName = name;
    genericName = name;
    categories = [ "Network" "WebBrowser" ];
  };

  tarball = "Wavebox_${version}.tar.gz";

in
stdenv.mkDerivation {
  pname = "wavebox";
  inherit version;
  src = fetchurl {
    url = "https://download.wavebox.app/stable/linux/tar/${tarball}";
    sha256 = "1g2mf3xmcaz3y6vwa65r4ccw71ddqj1cn12p0k1f1xawfl74kc5c";
  };

  # don't remove runtime deps
  dontPatchELF = true;
  # ignore optional Qt 6 shim
  autoPatchelfIgnoreMissingDeps = [ "libQt6Widgets.so.6" "libQt6Gui.so.6" "libQt6Core.so.6" ];

  nativeBuildInputs = [ autoPatchelfHook makeWrapper qt5.wrapQtAppsHook ];

  buildInputs = with xorg; [
    libXdmcp
    libXScrnSaver
    libXtst
    libxshmfence
    libXdamage
  ] ++ [
    alsa-lib
    gtk3
    nss
    libdrm
    mesa
    gtk4
    qt5.qtbase
  ];

  runtimeDependencies = [ (lib.getLib udev) libnotify gtk4 ];

  installPhase = ''
    mkdir -p $out/bin $out/opt/wavebox
    cp -r * $out/opt/wavebox

    # provide desktop item and icon
    mkdir -p $out/share/applications $out/share/icons/hicolor/128x128/apps
    ln -s ${desktopItem}/share/applications/* $out/share/applications
    ln -s $out/opt/wavebox/product_logo_128.png $out/share/icons/hicolor/128x128/apps/wavebox.png
  '';

  postFixup = ''
    makeWrapper $out/opt/wavebox/wavebox-launcher $out/bin/wavebox \
    --prefix PATH : ${xdg-utils}/bin
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Wavebox messaging application";
    homepage = "https://wavebox.io";
    license = licenses.mpl20;
    maintainers = with maintainers; [ rawkode ];
    platforms = [ "x86_64-linux" ];
    hydraPlatforms = [ ];
  };
}
