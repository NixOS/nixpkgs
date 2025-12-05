{
  stdenv,
  lib,
  requireFile,
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
  libidn2,
  libdeflate,
  brotli,
  libxkbcommon,
  libxcb,
  xorg,
  wayland,
  libudev0-shim,
  bubblewrap,
  libjpeg8,
  gdk-pixbuf,
  gtk3,
  pango,
  buildFHSEnv,
}:

let
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

  pname = "pixinsight";
  version = "1.9.3-20250402";

  installPkg = stdenv.mkDerivation (finalAttrs: {
    inherit meta pname version;

    src = requireFile rec {
      name = "PI-linux-x64-${finalAttrs.version}-c.tar.xz";
      url = "https://pixinsight.com/";
      hash = "sha256-MOAWH64A13vVLeNiBC9nO78P0ELmXXHR5ilh5uUhWhs=";
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
      mailcap
      libudev0-shim
      bubblewrap
    ];

    postPatch = ''
      patchelf ./installer \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath ${lib.getLib stdenv.cc.cc}/lib
    '';

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

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

      runHook postInstall
    '';

  });

  runPkg = buildFHSEnv {
    inherit meta pname version;

    targetPkgs =
      pkgs:
      with pkgs;
      [
        # PI itself
        installPkg
        # runtime deps
        mailcap
        libudev0-shim
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
        libidn2
        libdeflate
        brotli
        libxkbcommon
        libxcb
      ]
      ++ (with pkgs.xorg; [
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

    profile = ''
      export QT_QPA_PLATFORM_PLUGIN_PATH=/opt/PixInsight/bin/lib/qt-plugins/platforms
      export QT_PLUGIN_PATH=/opt/PixInsight/bin/lib/qt-plugins
      export LD_LIBRARY_PATH=${libudev0-shim}/lib
    '';

    runScript = "${installPkg}/bin/PixInsight";
  };

in
runPkg
