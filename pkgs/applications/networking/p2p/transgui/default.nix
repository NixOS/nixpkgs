{ lib, stdenv, fetchFromGitHub, pkg-config, makeDesktopItem, unzip, fpc, lazarus,
libX11, glib, gtk2, gdk-pixbuf, pango, atk, cairo, openssl }:

stdenv.mkDerivation rec {
  pname = "transgui";
  version = "5.18.0";

  src = fetchFromGitHub {
    owner = "transmission-remote-gui";
    repo = "transgui";
    rev = "v${version}";
    sha256 = "1dyx778756zhvz5sxgdvy49p2c0x44w4nmcfd90wqrmgfknncnf5";
  };

  nativeBuildInputs = [ pkg-config unzip ];
  buildInputs = [
    fpc lazarus stdenv.cc
    libX11 glib gtk2 gdk-pixbuf pango atk cairo openssl
  ];

  NIX_LDFLAGS = "
    -L${stdenv.cc.cc.lib}/lib
    -lX11 -lglib-2.0 -lgtk-x11-2.0 -lgdk-x11-2.0
    -lgdk_pixbuf-2.0 -lpango-1.0 -latk-1.0 -lcairo -lc -lcrypto
  ";

  prePatch = ''
    substituteInPlace restranslator.pas --replace /usr/ $out/
  '';

  preBuild = ''
    FPCDIR=${fpc}/lib/fpc/${fpc.version} fpcmake -w
    lazbuild -B transgui.lpr --lazarusdir=${lazarus}/share/lazarus
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
    categories = [ "Application" "Network" "FileTransfer" "P2P" "GTK" ];
    startupNotify = true;
    mimeTypes = [ "application/x-bittorrent" "x-scheme-handler/magnet" ];
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
    homepage = "https://sourceforge.net/p/transgui";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ramkromberg ];
    platforms = lib.platforms.linux;
  };
}
