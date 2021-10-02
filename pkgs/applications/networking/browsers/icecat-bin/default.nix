{ stdenv
, lib
, fetchzip
, autoPatchelfHook
, wrapGAppsHook
, gnome2
, gtk2
, nss
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
  pname = "icecat-bin";
  version = "60.7.0";

  src = fetchzip {
    url = "https://mirror.tochlab.net/pub/gnu/gnuzilla/${version}/icecat-${version}.en-US.gnulinux-x86_64.tar.bz2";
    sha256 = "sha256-bEapbQIcZXQ0Tip/X1Q0guowpr3wNDYsFbHGmTbc5mE=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook
  ];

  buildInputs = [
    nss
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
    gtk2
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
    xorg.libXt
    stdenv.cc.cc.lib
  ];

  unpackPhase = ''
    mkdir -p $TMP/ $out/{opt,bin}
    cp $src/* $TMP/ -r
  '';

  installPhase = ''
    cp -r $TMP/* $out/opt/
    ln -sf $out/opt/icecat-bin $out/bin/icecat
  '';

  runtimeDependencies = [
    libpulseaudio.out
    (lib.getLib systemd)
  ];

  meta = with lib; {
    description = "Binary build of the GNU version of the Mozilla Firefox browser";
    homepage = "https://www.gnu.org/software/gnuzilla/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
