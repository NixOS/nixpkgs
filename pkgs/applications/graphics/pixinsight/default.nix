{
  stdenv,
  lib,
  requireFile,
  wrapQtAppsHook,
  autoPatchelfHook,
  unixtools,
  fakeroot,
  mailcap,
  libGL,
  libpulseaudio,
  alsa-lib,
  nss,
  gd,
  gst_all_1,
  nspr,
  expat,
  fontconfig,
  dbus,
  glib,
  zlib,
  openssl,
  libdrm,
  cups,
  avahi-compat,
  xorg,
  wayland,
  libudev0-shim,
  bubblewrap,
  libjpeg8,
  gdk-pixbuf,
  gtk3,
  pango,
  # Qt 6 subpackages
  qtbase,
  qtserialport,
  qtserialbus,
  qtvirtualkeyboard,
  qtmultimedia,
  qt3d,
  mlt,
  qtlocation,
  qtwebengine,
  qtquick3d,
  qtwayland,
  qtwebview,
  qtscxml,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pixinsight";
  version = "1.8.9-3-20240625";

  src = requireFile rec {
    name = "PI-linux-x64-${finalAttrs.version}-c.tar.xz";
    url = "https://pixinsight.com/";
    hash = "sha256-jqp5pt+fC7QvENCwRjr7ENQiCZpwNhC5q76YdzRBJis=";
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
    mailcap
    libudev0-shim
    bubblewrap
  ];

  buildInputs =
    [
      (lib.getLib stdenv.cc.cc)
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
      libjpeg8
      gdk-pixbuf
      gtk3
      pango
      # Qt stuff
      qt3d
      mlt
      qtbase
      #qtgamepad
      qtserialport
      qtserialbus
      qtvirtualkeyboard
      qtmultimedia
      qtlocation
      qtwebengine
      qtquick3d
      qtwayland
      qtwebview
      qtscxml
    ]
    ++ (with xorg; [
      libX11
      libXdamage
      xrandr
      libXtst
      libXcomposite
      libXext
      libXfixes
      libXrandr
      libxkbfile
    ]);

  postPatch = ''
    patchelf ./installer \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${lib.getLib stdenv.cc.cc}/lib
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin $out/opt/PixInsight $out/share/{applications,mime/packages,icons/hicolor}

    bwrap --bind /build /build --bind $out/opt /opt --bind /nix /nix --dev /dev fakeroot script -ec "./installer \
      --yes \
      --install-desktop-dir=$out/share/applications \
      --install-mime-dir=$out/share/mime \
      --install-icons-dir=$out/share/icons/hicolor \
      --no-bin-launcher \
      --no-remove"

    rm -rf $out/opt/PixInsight-old-0
    ln -s $out/opt/PixInsight/bin/PixInsight $out/bin/.
    ln -s $out/opt/PixInsight/bin/lib $out/lib

    # Remove signatures of plugins, as they are only working if actually installed
    # under /opt. In the Nix setup, they are causing trouble.
    find $out/opt/PixInsight/ -name "*.xsgn" -exec rm {} \;
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
    wrapProgram $out/opt/PixInsight/bin/PixInsight ${builtins.toString finalAttrs.qtWrapperArgs}
  '';

  meta = with lib; {
    description = "Scientific image processing program for astrophotography";
    homepage = "https://pixinsight.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.sheepforce ];
    hydraPlatforms = [ ];
    mainProgram = "PixInsight";
  };
})
