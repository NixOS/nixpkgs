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
  version = "10.114.26-2";
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
    sha256 = "1yk664zgahjg6n98n3kc9avcay0nqwcyq8wq231p7kvd79zazk0r";
  };

  # don't remove runtime deps
  dontPatchELF = true;

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

  meta = with lib; {
    description = "Wavebox messaging application";
    homepage = "https://wavebox.io";
    license = licenses.mpl20;
    maintainers = with maintainers; [ rawkode ];
    platforms = [ "x86_64-linux" ];
    hydraPlatforms = [ ];
  };
}
