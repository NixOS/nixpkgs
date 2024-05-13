{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, wrapGAppsHook3
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
, libqt5pas
, qt6
, vivaldi-ffmpeg-codecs
, edition ? "stable"
}:

let
  version = {
    corporate = "24.1.3.843-1";
    beta = "24.4.1.918-1";
    stable = "24.4.1.915-1";
  }.${edition};

  hash = {
    corporate = "sha256-rI19YmsC2p2Dsi6Grd8IyNdpjMHWwET3wcVw5r7545M=";
    beta = "sha256-EQjjaTMPQKaULITEF+MQuY1lRVXuOjyiGWuGQtIpIz0=";
    stable = "sha256-2IIIADFG9kCtzB0X4AfrFI+btqoUzKwd6NlZt7qtL/M=";
  }.${edition};

  app = {
    corporate = "";
    beta = "-beta";
    stable = "";
  }.${edition};

in stdenv.mkDerivation rec {
  pname = "yandex-browser-${edition}";
  inherit version;

  src = fetchurl {
    url = "http://repo.yandex.ru/yandex-browser/deb/pool/main/y/${pname}/${pname}_${version}_amd64.deb";
    inherit hash;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    qt6.wrapQtAppsHook
    wrapGAppsHook3
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
    libqt5pas
    qt6.qtbase
  ];

  unpackPhase = ''
    mkdir $TMP/ya/ $out/bin/ -p
    ar vx $src
    tar --no-overwrite-dir -xvf data.tar.xz -C $TMP/ya/
  '';

  installPhase = ''
    cp $TMP/ya/{usr/share,opt} $out/ -R
    cp $out/share/applications/yandex-browser${app}.desktop $out/share/applications/${pname}.desktop || true
    rm -f $out/share/applications/yandex-browser.desktop
    substituteInPlace $out/share/applications/${pname}.desktop --replace /usr/ $out/
    substituteInPlace $out/share/menu/yandex-browser${app}.menu --replace /opt/ $out/opt/
    substituteInPlace $out/share/gnome-control-center/default-apps/yandex-browser${app}.xml --replace /opt/ $out/opt/
    ln -sf ${vivaldi-ffmpeg-codecs}/lib/libffmpeg.so $out/opt/yandex/browser${app}/libffmpeg.so
    ln -sf $out/opt/yandex/browser${app}/yandex-browser${app} $out/bin/${pname}
  '';

  runtimeDependencies = map lib.getLib [
    libpulseaudio
    curl
    systemd
    vivaldi-ffmpeg-codecs
  ] ++ buildInputs;

  meta = with lib; {
    description = "Yandex Web Browser";
    homepage = "https://browser.yandex.ru/";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ dan4ik605743 ionutnechita ];
    platforms = [ "x86_64-linux" ];
  };
}
