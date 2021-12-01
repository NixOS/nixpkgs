{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, wrapGAppsHook
, flac
, gnome2
, harfbuzzFull
, nss
, snappy
, xdg-utils
, xorg
, alsa-lib
, atk
, cairo
, cups
, curl
, dbus
, expat
, fontconfig
, freetype
, gdk-pixbuf
, glib
, gtk3
, libX11
, libxcb
, libXScrnSaver
, libXcomposite
, libXcursor
, libXdamage
, libXext
, libXfixes
, libXi
, libXrandr
, libXrender
, libXtst
, libdrm
, libnotify
, libopus
, libpulseaudio
, libuuid
, libxshmfence
, mesa
, nspr
, pango
, systemd
, at-spi2-atk
, at-spi2-core
}:

stdenv.mkDerivation rec {
  pname = "yandex-browser";
  version = "21.6.2.817-1";

  src = fetchurl {
    url = "http://repo.yandex.ru/yandex-browser/deb/pool/main/y/${pname}-beta/${pname}-beta_${version}_amd64.deb";
    sha256 = "sha256-xeZkQzVPPNABxa3/YBLoZl1obbFdzxdqIgLyoA4PN8U=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook
  ];

  buildInputs = [
    flac
    harfbuzzFull
    nss
    snappy
    xdg-utils
    xorg.libxkbfile
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    curl
    dbus
    expat
    fontconfig.lib
    freetype
    gdk-pixbuf
    glib
    gnome2.GConf
    gtk3
    libX11
    libXScrnSaver
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    libdrm
    libnotify
    libopus
    libuuid
    libxcb
    libxshmfence
    mesa
    nspr
    nss
    pango
    stdenv.cc.cc.lib
  ];

  unpackPhase = ''
    mkdir -p $TMP/ya $out/bin
    cp $src $TMP/ya.deb
    ar vx ya.deb
    tar --no-overwrite-dir -xvf data.tar.xz -C $TMP/ya/
  '';

  installPhase = ''
    cp -R $TMP/ya/opt $out/
    ln -sf $out/opt/yandex/browser-beta/yandex_browser $out/bin/yandex-browser
  '';

  runtimeDependencies = [
    libpulseaudio.out
    (lib.getLib systemd)
  ];

  meta = with lib; {
    description = "Yandex Web Browser";
    homepage = "https://browser.yandex.ru/";
    license = licenses.unfree;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = [ "x86_64-linux" ];
    broken = true;
  };
}
