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
    corporate = "24.4.3.1073-1";
    beta = "24.4.1.952-1";
    stable = "24.4.1.951-1";
  }.${edition};

  hash = {
    corporate = "sha256-f2Q6q3rL+RcVYX46RHRAageF2JKPxmBaV6KHYl5XtN8=";
    beta = "sha256-WCyjgb5uj9guqyge6giP0wavndorlMG6yacG134xWjw=";
    stable = "sha256-4AsMpANtMXUS2NCPKI+Ut0tWGurRIpWCmS3PhEi1CGo=";
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
