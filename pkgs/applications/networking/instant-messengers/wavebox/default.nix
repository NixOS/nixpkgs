{ alsa-lib
, autoPatchelfHook
, fetchurl
, gtk3
, gtk4
, libnotify
, copyDesktopItems
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

stdenv.mkDerivation rec {
  pname = "wavebox";
  version = "10.120.10-2";

  src = fetchurl {
    url = "https://download.wavebox.app/stable/linux/tar/Wavebox_${version}.tar.gz";
    sha256 = "sha256-9kA3nJUNlNHbWYkIy0iEnWCrmIYTjULdMAGGnO4JCkg=";
  };

  # don't remove runtime deps
  dontPatchELF = true;
  # ignore optional Qt 6 shim
  autoPatchelfIgnoreMissingDeps = [ "libQt6Widgets.so.6" "libQt6Gui.so.6" "libQt6Core.so.6" ];

  nativeBuildInputs = [ autoPatchelfHook makeWrapper qt5.wrapQtAppsHook copyDesktopItems ];

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

  desktopItems = [
    (makeDesktopItem rec {
      name = "Wavebox";
      exec = "wavebox";
      icon = "wavebox";
      desktopName = name;
      genericName = name;
      categories = [ "Network" "WebBrowser" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/opt/wavebox
    cp -r * $out/opt/wavebox

    # provide icon for desktop item
    mkdir -p $out/share/icons/hicolor/128x128/apps
    ln -s $out/opt/wavebox/product_logo_128.png $out/share/icons/hicolor/128x128/apps/wavebox.png

    runHook postInstall
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
