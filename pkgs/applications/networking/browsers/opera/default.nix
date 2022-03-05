{ alsa-lib
, atk
, cairo
, cups
, curl
, dbus
, dpkg
, expat
, fetchurl
, fontconfig
, freetype
, gdk-pixbuf
, glib
, gtk3
, gtk4
, lib
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
, libpulseaudio
, libuuid
, libxshmfence
, mesa
, nspr
, nss
, pango
, stdenv
, systemd
, at-spi2-atk
, at-spi2-core
, autoPatchelfHook
, wrapGAppsHook
}:

let

  mirror = "https://get.geo.opera.com/pub/opera/desktop";

in stdenv.mkDerivation rec {

  pname = "opera";
  version = "83.0.4254.54";

  src = fetchurl {
    url = "${mirror}/${version}/linux/${pname}-stable_${version}_amd64.deb";
    sha256 = "sha256-kv90FmenGpAbNyw/puwEbR/vVNHV2d5UdX3amMTcI7k=";
  };

  unpackCmd = "${dpkg}/bin/dpkg-deb -x $curSrc .";

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook
  ];

  buildInputs = [
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
    libuuid
    libxcb
    libxshmfence
    mesa
    nspr
    nss
    pango
    stdenv.cc.cc.lib
  ];

  runtimeDependencies = [
    # Works fine without this except there is no sound.
    libpulseaudio.out

    # This is a little tricky. Without it the app starts then crashes. Then it
    # brings up the crash report, which also crashes. `strace -f` hints at a
    # missing libudev.so.0.
    (lib.getLib systemd)

    # Error at startup:
    # "Illegal instruction (core dumped)"
    gtk3
    gtk4
  ];

  installPhase = ''
    mkdir -p $out
    cp -r . $out/
  '';

  meta = with lib; {
    homepage = "https://www.opera.com";
    description = "Web browser";
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
  };
}
