{ alsaLib
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
, gnome2
, gtk3
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
, libnotify
, libpulseaudio
, libuuid
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
  version = "66.0.3515.36";

  src = fetchurl {
    url = "${mirror}/${version}/linux/${pname}-stable_${version}_amd64.deb";
    sha256 = "1kmd8dxdid593a98a13n8k22hi1whvichda6qam2bqcz99rsczdd";
  };

  unpackCmd = "${dpkg}/bin/dpkg-deb -x $curSrc .";

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook
  ];

  buildInputs = [
    alsaLib
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
    libnotify
    libuuid
    libxcb
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
    systemd.lib
  ];

  installPhase = ''
    mkdir -p $out
    cp -r . $out/
    mv $out/lib/*/opera/*.so $out/lib/
  '';

  meta = with lib; {
    homepage = "https://www.opera.com";
    description = "Web browser";
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
  };
}
