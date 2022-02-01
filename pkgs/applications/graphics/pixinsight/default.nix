{ stdenv, lib, requireFile, wrapQtAppsHook, autoPatchelfHook, makeWrapper, unixtools, fakeroot
, mime-types, libGL, libpulseaudio, alsa-lib, nss, gd, gst_all_1, nspr, expat, fontconfig
, dbus, glib, zlib, openssl, libdrm, cups, avahi-compat, xorg, wayland, libudev0-shim
# Qt 5 subpackages
, qtbase, qtgamepad, qtserialport, qtserialbus, qtvirtualkeyboard, qtmultimedia, qtwebkit, qt3d, mlt
}:

stdenv.mkDerivation rec {
  pname = "pixinsight";
  version = "1.8.8-12";

  src = requireFile rec {
    name = "PI-linux-x64-${version}-20211229-c.tar.xz";
    url = "https://pixinsight.com/";
    sha256 = "7095b83a276f8000c9fe50caadab4bf22a248a880e77b63e0463ad8d5469f617";
    message = ''
      PixInsight is available from ${url} and requires a commercial (or trial) license.
      After a license has been obtained, PixInsight can be downloaded from the software distribution
      (choose Linux 64bit).
      The PixInsight tarball must be added to the nix-store, i.e. via
        nix-prefetch-url --type sha256 file:///path/to/${name}
    '';
  };
  sourceRoot = ".";

  nativeBuildInputs = [
    unixtools.script
    fakeroot
    wrapQtAppsHook
    autoPatchelfHook
    mime-types
    libudev0-shim
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    stdenv.cc
    libGL
    libpulseaudio
    alsa-lib
    nss
    gd
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    nspr
    expat
    fontconfig
    dbus
    glib
    zlib
    openssl
    libdrm
    wayland
    cups
    avahi-compat
    # Qt stuff
    qt3d
    mlt
    qtbase
    qtgamepad
    qtserialport
    qtserialbus
    qtvirtualkeyboard
    qtmultimedia
    qtwebkit
  ] ++ (with xorg; [
    libX11
    libXdamage
    xrandr
    libXtst
    libXcomposite
    libXext
    libXfixes
    libXrandr
  ]);

  postPatch = ''
    patchelf ./installer \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${stdenv.cc.cc.lib}/lib
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin $out/opt/PixInsight $out/share/{applications,mime/packages,icons/hicolor}

    fakeroot script -ec "./installer \
      --yes \
      --install-dir=$out/opt/PixInsight \
      --install-desktop-dir=$out/share/applications \
      --install-mime-dir=$out/share/mime \
      --install-icons-dir=$out/share/icons/hicolor \
      --no-bin-launcher \
      --no-remove"

    rm -rf $out/opt/PixInsight-old-0
    ln -s $out/opt/PixInsight/bin/PixInsight $out/bin/.
  '';

  # Some very exotic Qt libraries are not available in nixpkgs
  autoPatchelfIgnoreMissingDeps = true;

  # This mimics what is happening in PixInsight.sh and adds on top the libudev0-shim, which
  # without PixInsight crashes at startup.
  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${libudev0-shim}/lib"
    "--set LC_ALL en_US.utf8"
    "--set AVAHI_COMPAT_NOWARN 1"
    "--set QT_PLUGIN_PATH $out/opt/PixInsight/bin/lib/qt-plugins"
    "--set QT_QPA_PLATFORM_PLUGIN_PATH $out/opt/PixInsight/bin/lib/qt-plugins/platforms"
    "--set QT_AUTO_SCREEN_SCALE_FACTOR 0"
    "--set QT_ENABLE_HIGHDPI_SCALING 0"
    "--set QT_SCALE_FACTOR 1"
    "--set QT_LOGGING_RULES '*=false'"
    "--set QTWEBENGINEPROCESS_PATH $out/opt/PixInsight/bin/libexec/QtWebEngineProcess"
  ];
  dontWrapQtApps = true;
  postFixup = ''
    wrapProgram $out/opt/PixInsight/bin/PixInsight ${builtins.toString qtWrapperArgs}
  '';

  meta = with lib; {
    description = "Scientific image processing program for astrophotography";
    homepage = "https://pixinsight.com/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.sheepforce ];
    mainProgram = "PixInsight";
  };
}
