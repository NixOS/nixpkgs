{ lib
, stdenv
, fetchurl
, dpkg
, autoPatchelfHook
, makeWrapper
, alsa-lib
, at-spi2-atk
, at-spi2-core
, atk
, cairo
, cups
, dbus
, expat
, fontconfig
, freetype
, gdk-pixbuf
, glib
, gtk3
, libdrm
, libX11
, libXcomposite
, libXdamage
, libXext
, libXfixes
, libXrandr
, libxcb
, libxkbcommon
, mesa
, nspr
, nss
, pango
, systemd
, xdg-utils
}:

stdenv.mkDerivation rec {
  pname = "helium";
  version = "0.12.3.1";

  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-bin_${version}-1_amd64.deb";
    hash = "sha256:f3c6574766537f7438a28bc9dcca93031af41e624737e6774d232e038f2d6661";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libX11
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXrandr
    libxcb
    libxkbcommon
    mesa
    nspr
    nss
    pango
    systemd
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libQt5Core.so.5"
    "libQt5Gui.so.5"
    "libQt5Widgets.so.5"
    "libQt6Core.so.6"
    "libQt6Gui.so.6"
    "libQt6Widgets.so.6"
  ];

  unpackPhase = ''
    mkdir -p $out
    dpkg-deb -x $src extracted
  '';

  installPhase = ''
    mkdir -p $out/opt/helium $out/bin $out/share/applications $out/share/icons

    cp -r extracted/opt/helium/. $out/opt/helium/

    cp extracted/opt/helium/helium.desktop $out/share/applications/helium.desktop
    cp extracted/opt/helium/product_logo_256.png $out/share/icons/helium.png

    substituteInPlace $out/share/applications/helium.desktop \
      --replace-warn "Exec=/opt/helium/helium-wrapper" "Exec=$out/bin/helium"

    wrapProgram $out/opt/helium/helium \
      --prefix PATH : ${lib.makeBinPath [ xdg-utils ]} \
      --add-flags "--no-sandbox"

    ln -s $out/opt/helium/helium $out/bin/helium
  '';

  postFixup = ''
    addAutoPatchelfSearchPath $out/opt/helium
  '';

  meta = with lib; {
    description = "Privacy-focused browser based on Chromium, without Google";
    homepage = "https://helium.computer";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ skyblocknooobb ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
