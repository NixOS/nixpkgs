{ GConf
, alsaLib
, at-spi2-atk
, atk
, cairo
, cups
, dbus
, expat
, fetchurl
, fontconfig
, gdk_pixbuf
, glib
, gtk2
, gtk3
, lib
, libX11
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
, libappindicator
, libdrm
, libnotify
, libpciaccess
, libpng12
, libxcb
, nspr
, nss
, pango
, pciutils
, pulseaudio
, stdenv
, udev
, wrapGAppsHook
}:

let
  libs = [
    GConf
    alsaLib
    at-spi2-atk
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    gdk_pixbuf
    glib
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
    libappindicator
    libdrm
    libnotify
    libpciaccess
    libpng12
    libxcb
    nspr
    nss
    pango
    pciutils
    pulseaudio
    stdenv.cc.cc.lib
    udev
  ];

  libPath = lib.makeLibraryPath libs;
in

stdenv.mkDerivation rec {
  pname = "stretchly";
  version = "0.19.1";

  src = fetchurl {
    url = "https://github.com/hovancik/stretchly/releases/download/v${version}/stretchly-${version}.tar.xz";
    sha256 = "1q2wxfqs8qv9b1rfh5lhmyp3rrgdl05m6ihsgkxlgp0yzi07afz8";
  };

  nativeBuildInputs = [
    wrapGAppsHook
  ];

  buildInputs = libs;

  dontPatchELF = true;
  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/bin $out/lib/stretchly
    cp -r ./* $out/lib/stretchly/
    ln -s $out/lib/stretchly/libffmpeg.so $out/lib/
    ln -s $out/lib/stretchly/libnode.so $out/lib/
    ln -s $out/lib/stretchly/stretchly $out/bin/
  '';

  preFixup = ''
    patchelf --set-rpath "${libPath}" $out/lib/stretchly/libffmpeg.so
    patchelf --set-rpath "${libPath}" $out/lib/stretchly/libnode.so

    patchelf \
      --set-rpath "$out/lib/stretchly:${libPath}" \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/lib/stretchly/stretchly
  '';

  meta = with stdenv.lib; {
    description = "A break time reminder app";
    longDescription = ''
      stretchly is a cross-platform electron app that reminds you to take
      breaks when working on your computer. By default, it runs in your tray
      and displays a reminder window containing an idea for a microbreak for 20
      seconds every 10 minutes. Every 30 minutes, it displays a window
      containing an idea for a longer 5 minute break.
    '';
    homepage = https://hovancik.net/stretchly;
    downloadPage = https://hovancik.net/stretchly/downloads/;
    license = licenses.bsd2;
    maintainers = with maintainers; [ cdepillabout ];
    platforms = platforms.linux;
  };
}
