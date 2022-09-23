{ lib, stdenv, fetchFromGitHub, pkg-config, makeDesktopItem, fetchpatch, unzip
, fpc, lazarus, libX11, glib, gtk2, gdk-pixbuf, pango, atk, cairo, openssl }:

stdenv.mkDerivation rec {
  pname = "transgui";
  version = "unstable-2022-02-02";

  src = fetchFromGitHub {
    owner = "transmission-remote-gui";
    repo = "transgui";
    rev = "0e2c2a07c1b21b1704c0a4945a111a8aa1050a1a";
    sha256 = "1x9wzii3q9zanpik4xc99jqsfrqch8vjmlx12jrvczxcfy51b1ba";
  };

  patches = [
    # TDDO: remove when transgui updates for transmission-daemon v3 rpc protocol
    (fetchpatch {
      url = "https://github.com/transmission-remote-gui/transgui/commit/9275c3fb877dd753a1940d1b900630cdc09a0cc2.patch";
      sha256 = "0w2x7gcxp5kqczdz7ckfqhdz9hhkm62k8gcws54d6km7x9vc1023";
    })
  ];

  nativeBuildInputs = [ pkg-config unzip ];
  buildInputs = [
    fpc lazarus stdenv.cc libX11 glib gtk2 gdk-pixbuf
    pango atk cairo openssl
  ];

  NIX_LDFLAGS = ''
    -L${stdenv.cc.cc.lib}/lib -lX11 -lglib-2.0 -lgtk-x11-2.0
    -lgdk-x11-2.0 -lgdk_pixbuf-2.0 -lpango-1.0 -latk-1.0 -lcairo
    -lc -lcrypto
  '';

  postPatch = ''
    substituteInPlace restranslator.pas --replace /usr/ $out/
  '';

  preBuild = ''
    FPCDIR=${fpc}/lib/fpc/${fpc.version} fpcmake -w
    lazbuild -B transgui.lpr --lazarusdir=${lazarus}/share/lazarus
  '';

  makeFlags = [ "FPC=fpc" "PP=fpc" "INSTALL_PREFIX=$(out)" ];

  LCL_PLATFORM = "gtk2";

  desktopItem = makeDesktopItem {
    name = pname;
    exec = "${pname} %U";
    icon = pname;
    type = "Application";
    comment = meta.description;
    desktopName = "Transmission Remote GUI";
    genericName = "BitTorrent Client";
    categories = [ "Network" "FileTransfer" "P2P" "GTK" ];
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
    description = "A cross platform front-end for the Transmission BitTorrent client";
    homepage = "https://sourceforge.net/p/transgui";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ramkromberg ];
    mainProgram = "transgui";
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
