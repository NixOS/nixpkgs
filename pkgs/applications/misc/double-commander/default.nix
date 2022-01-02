{ lib
, stdenv
, autoPatchelfHook
, fetchFromGitHub
, lazarus
, fpc
, libX11
, glib
, dbus

  # GTK2
, gtk2
, atk
, pango
, gdk-pixbuf
, cairo

  # Qt5
, libqt5pas
, qt5
, widgetset ? "qt5"
}:

stdenv.mkDerivation rec {
  pname = "doublecmd";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "doublecmd";
    repo = "doublecmd";
    rev = "v${version}";
    sha256 = "sha256-DVEFflk+gEcqWbAvCri4v1O3oOOXUMBYFKRifDpX1y4=";
  };

  nativeBuildInputs = [ lazarus fpc autoPatchelfHook ]
    ++ lib.optional (widgetset == "qt5") qt5.wrapQtAppsHook;

  buildInputs = [ libX11 glib dbus ]
    ++ lib.optionals (widgetset == "gtk2") [ gtk2 atk pango gdk-pixbuf cairo ]
    ++ lib.optional (widgetset == "qt5") libqt5pas;

  buildPhase = ''
   lazbuild --lazarusdir=${lazarus}/share/lazarus --pcp=./lazarus --widgetset=${widgetset} \
      components/chsdet/chsdet.lpk \
      components/CmdLine/cmdbox.lpk \
      components/multithreadprocs/multithreadprocslaz.lpk \
      components/dcpcrypt/dcpcrypt.lpk \
      components/doublecmd/doublecmd_common.lpk \
      components/KASToolBar/kascomp.lpk \
      components/viewer/viewerpackage.lpk \
      components/gifanim/pkg_gifanim.lpk \
      components/synunihighlighter/synuni.lpk \
      src/doublecmd.lpi

    # TODO build plugins
    # build plugins
    # WCX plugins
    # lazbuild plugins/wcx/cpio/src/cpio.lpi
    # lazbuild plugins/wcx/deb/src/deb.lpi
    # lazbuild plugins/wcx/rpm/src/rpm.lpi
    # lazbuild plugins/wcx/unrar/src/unrar.lpi
    # lazbuild plugins/wcx/zip/src/Zip.lpi

    # # WDX plugins
    # lazbuild plugins/wdx/rpm_wdx/src/rpm_wdx.lpi
    # lazbuild plugins/wdx/deb_wdx/src/deb_wdx.lpi
    # lazbuild plugins/wdx/xpi_wdx/src/xpi_wdx.lpi
    # lazbuild plugins/wdx/audioinfo/src/AudioInfo.lpi

    # # WFX plugins
    # lazbuild plugins/wfx/ftp/src/ftp.lpi
    # lazbuild plugins/wfx/samba/src/samba.lpi
    # lazbuild plugins/wlx/WlxMplayer/src/wlxMplayer.lpi

    # # DSX plugins
    # lazbuild plugins/dsx/DSXLocate/src/DSXLocate.lpi
  '';

  installPhase = ''
    install -Dt $out/bin doublecmd
    install -Dm644 install/linux/doublecmd.desktop -t $out/share/applications
    install -Dm644 doublecmd.png -t $out/share/pixmaps
    install -Dm644 install/linux/*.1 -t $out/share/man/man1

    # TODO pixmaps don't seem to work
    install -Dt $out/share pixmaps.txt
    mkdir -p $out/share/pixmaps
    cp -R pixmaps/* $out/share/pixmaps/
  '';

  meta = with lib; {
    description = "File manager with two panels side by side";
    homepage = "https://doublecmd.sourceforge.io/";
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" ]; # TODO other platforms/arch
    maintainers = with maintainers; [ mausch ];
  };
}
