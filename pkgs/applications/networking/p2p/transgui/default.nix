{ stdenv, fetchsvn, pkgconfig, makeDesktopItem, unzip, fpc, lazarus,
libX11, glib, gtk, gdk_pixbuf, pango, atk, cairo, openssl }:

stdenv.mkDerivation rec {
  name = "transgui-5.0.1-svn-r${revision}";
  revision = "986";

  src = fetchsvn {
    url = "https://svn.code.sf.net/p/transgui/code/trunk/";
    rev = revision;
    sha256 = "0z83hvlhllm6p1z4gkcfi1x3akgn2xkssnfhwp74qynb0n5362pi";
  };

  buildInputs = [
    pkgconfig unzip fpc lazarus stdenv.cc
    libX11 glib gtk gdk_pixbuf pango atk cairo openssl
  ];

  NIX_LDFLAGS = "
    -L${stdenv.cc.cc.lib}/lib
    -lX11 -lglib-2.0 -lgtk-x11-2.0 -lgdk-x11-2.0
    -lgdk_pixbuf-2.0 -lpango-1.0 -latk-1.0 -lcairo -lc -lcrypto
  ";

  prePatch = ''
    substituteInPlace restranslator.pas --replace /usr/ $out/
  '';

  makeFlags = [
    "FPC=fpc"
    "PP=fpc"
    "INSTALL_PREFIX=$(out)"
  ];

  LCL_PLATFORM = "gtk2"; 

  desktopItem = makeDesktopItem rec {
    name = "transgui";
    exec = name + " %U";
    icon = name;
    type = "Application";
    comment = meta.description;
    desktopName = "Transmission Remote GUI";
    genericName = "BitTorrent Client";
    categories = stdenv.lib.concatStringsSep ";" [
      "Application" "Network" "FileTransfer" "P2P" "GTK"
    ];
    startupNotify = "true";
    mimeType = stdenv.lib.concatStringsSep ";" [
      "application/x-bittorrent" "x-scheme-handler/magnet"
    ];
  };

  postInstall = ''
    mkdir -p "$out/share/applications"
    cp $desktopItem/share/applications/* $out/share/applications
    mkdir -p "$out/share/icons/hicolor/48x48/apps"
    cp transgui.png "$out/share/icons/hicolor/48x48/apps"
    mkdir -p "$out/share/transgui"
    cp -r "./lang" "$out/share/transgui" 
  '';

  meta = { 
    description = "A cross platform front-end for the Transmission Bit-Torrent client";
    homepage = https://sourceforge.net/p/transgui;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ ramkromberg ];
    platforms = stdenv.lib.platforms.linux;
  };
}
