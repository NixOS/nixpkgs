{
  addDriverRunpath,
  alsa-lib,
  autoPatchelfHook,
  curl,
  fetchurl,
  fetchzip,
  freetype,
  gobject-introspection,
  gst_all_1,
  gtk3,
  gzip,
  lcms2,
  lib,
  libGLU,
  libgphoto2,
  libice,
  libpcap,
  libpng,
  libpulseaudio,
  libsm,
  libunwind,
  libusb1,
  libxcursor,
  libxext,
  libxi,
  libxrandr,
  makeDesktopItem,
  nix-update,
  ocl-icd,
  openssl,
  pcsclite,
  perl,
  pkgsi686Linux,
  python3,
  rpmextract,
  runCommand,
  sane-backends,
  stdenv,
  vte,
  writeShellScript,
  wrapGAppsHook3,
  xdg-utils,
  zlib,
}:

let
  pname = "crossover";
  version = "26.3.0";

  # checkgtk.py calls gi.require_foreign('cairo') and treats a failure as
  # "GTK 3 support missing", so pycairo has to ride along with PyGObject.
  pythonEnv = python3.withPackages (ps: [
    ps.pygobject3
    ps.pycairo
  ]);

  # The rpm already ships share/applications/wine.desktop, but that one is
  # NoDisplay and just launches whatever .exe you hand it; this is the entry
  # for the CrossOver control panel itself.
  desktopItem = makeDesktopItem {
    name = "crossover";
    desktopName = "CrossOver";
    comment = "Run your Windows® app on MacOS and Linux";
    exec = "crossover";
    icon = "crossover";
    categories = [ "System" ];
    # argv[0] after the makeWrapper rename is ".crossover-wrapped", which is
    # what taskbars match windows against.
    startupWMClass = ".crossover-wrapped";
  };

  src =
    {
      x86_64-linux = fetchurl {
        url = "https://media.codeweavers.com/pub/crossover/cxlinux/demo/crossover-${version}-1.rpm";
        hash = "sha256-M4pHI/sjlOqjr2jz1I0OPPW1p359wKZVcKVnNA9TpNo=";
      };
      aarch64-darwin = fetchzip {
        url = "https://media.codeweavers.com/pub/crossover/cxmac/demo/crossover-${version}.zip";
        hash = "sha256-AzH1rZFqEH8sovZZfJykvsEmCedEZWigQFHWHl6/PdE=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  meta = {
    description = "Run your Windows® app on MacOS and Linux";
    homepage = "https://www.codeweavers.com/crossover";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = with lib.licenses; unfree;
    mainProgram = "crossover";
    maintainers = with lib.maintainers; [ shymega ];
    platforms = [
      "aarch64-darwin"
      "x86_64-linux"
    ];
  };

  # CodeWeavers doesn't publish a version index; these stable redirect
  # endpoints (used by their own download buttons) 302 to the current
  # release's URL, so the version can be read straight off the
  # Location header instead of scraping any HTML.
  updateScript = writeShellScript "crossover-updater" ''
    set -eu -o pipefail
    PATH=${
      lib.makeBinPath [
        curl
        nix-update
      ]
    }:$PATH

    getVersion() {
      curl -sI "http://crossover.codeweavers.com/redirect/$1" \
        | grep -i '^location:' \
        | grep -oE '[0-9]+\.[0-9]+\.[0-9]+'
    }

    linuxVersion=$(getVersion crossover.rpm)
    darwinVersion=$(getVersion crossover.zip)

    nix-update crossover --version "$linuxVersion" --system x86_64-linux
    nix-update crossover --version "$darwinVersion" --system aarch64-darwin
  '';

  # Two SONAMEs Wine's binaries need that nixpkgs doesn't ship under that
  # name: libcapi20.so.3 (dead ISDN tech, provided as a stub reporting "not
  # installed") and libpcap.so.0.8 (a pre-1.0 SONAME for the same ABI
  # nixpkgs ships as libpcap.so.1). Built per bitness: the rpm ships a
  # complete 32-bit Wine alongside the 64-bit one, for win32 bottles.
  mkCapi20Stub =
    stdenv':
    stdenv'.mkDerivation {
      pname = "libcapi20-stub";
      inherit version;
      src = ./capi20.c;
      dontUnpack = true;
      buildPhase = ''
        $CC -shared -fPIC -Wl,-soname,libcapi20.so.3 -o libcapi20.so.3 $src
      '';
      installPhase = ''
        mkdir -p $out/lib
        cp libcapi20.so.3 $out/lib/
      '';
      meta.description = "Stub of the obsolete ISDN CAPI 2.0 library (libcapi20.so.3)";
    };
  capi20Stub64 = mkCapi20Stub stdenv;
  capi20Stub32 = mkCapi20Stub pkgsi686Linux.stdenv;

  mkPcap08Compat =
    libpcap':
    runCommand "libpcap-0.8-compat" { } ''
      mkdir -p $out/lib
      ln -s ${lib.getLib libpcap'}/lib/libpcap.so.1 $out/lib/libpcap.so.0.8
    '';
  pcap08Compat64 = mkPcap08Compat libpcap;
  pcap08Compat32 = mkPcap08Compat pkgsi686Linux.libpcap;

  compatLibs64 = [
    capi20Stub64
    pcap08Compat64
  ];
  compatLibs32 = [
    capi20Stub32
    pcap08Compat32
  ];

  # Wine dlopen()s most of these rather than linking them, so they carry no
  # DT_NEEDED entry for autoPatchelf to find; appended to the RUNPATH
  # explicitly below, otherwise fonts, audio, GL and printing silently break.
  # Mirrored for pkgsi686Linux so 32-bit bottles get the same treatment.
  runtimeLibs = [
    alsa-lib
    freetype
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gtk3
    lcms2
    libGLU
    libgphoto2
    libice
    libpng
    libpulseaudio
    libsm
    libunwind
    libusb1
    libxcursor
    libxext
    libxi
    libxrandr
    ocl-icd
    openssl
    pcsclite
    sane-backends
    vte # provides Vte-2.91.typelib, needed by the install wizard
    zlib
  ];
  runtimeLibs32 = [
    alsa-lib
    freetype
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gtk3
    lcms2
    libGLU
    libgphoto2
    libice
    libpng
    libpulseaudio
    libsm
    libunwind
    libusb1
    libxcursor
    libxext
    libxi
    libxrandr
    ocl-icd
    openssl
    pcsclite
    sane-backends
    vte
    zlib
  ];

  # GStreamer's plugin scanner reads GST_PLUGIN_SYSTEM_PATH_1_0 itself rather
  # than resolving plugins through the linker, so the 32-bit plugin dirs have
  # to be stated explicitly for win32 bottles.
  gstPluginDirs32 = map (p: "${lib.getLib p}/lib/gstreamer-1.0") (
    with pkgsi686Linux.gst_all_1;
    [
      gst-plugins-base
      gst-plugins-good
      gst-plugins-bad
      gst-plugins-ugly
      gst-libav
    ]
  );

  linux = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;

    passthru = {
      inherit updateScript;
    };

    nativeBuildInputs = [
      rpmextract
      autoPatchelfHook
      gobject-introspection
      wrapGAppsHook3
      # For the perl launchers (#!/usr/bin/perl) and the GUI's
      # #!/usr/bin/env python3, rewritten by patchShebangs below.
      perl
      pythonEnv
    ];

    buildInputs = runtimeLibs;

    runtimeDependencies = compatLibs64 ++ compatLibs32;

    appendRunpaths = [
      "${addDriverRunpath.driverLink}/lib"
    ]
    ++ map (p: "${lib.getLib p}/lib") (runtimeLibs ++ runtimeLibs32)
    ++ map (p: "${p}/lib") (compatLibs64 ++ compatLibs32);

    autoPatchelfIgnoreMissingDeps = [
      "libcapi20.so.3"
      "libpcap.so.0.8"
    ];

    unpackPhase = ''
      rpmextract $src
    '';

    installPhase = ''
            runHook preInstall

            mkdir -pv $out
            cp -R ./opt/cxoffice/* $out/

            mkdir -p $out/share/applications
            cp ${desktopItem}/share/applications/*.desktop $out/share/applications/

            for size in 16 32 48 64 128 256; do
              mkdir -p $out/share/icons/hicolor/''${size}x''${size}/apps
              cp ./opt/cxoffice/share/icons/''${size}x''${size}/crossover.png \
                $out/share/icons/hicolor/''${size}x''${size}/apps/crossover.png
            done

            # perl launchers have no interpreter on NixOS without this; --build
            # (not the strictDeps default --host) because perl/pythonEnv are
            # nativeBuildInputs, not buildInputs.
            patchShebangs --build $out

            # makeWrapper renames executables to '.<name>-wrapped'; the perl
            # launchers read their own name from $0 and would otherwise mistake
            # themselves for a winelib app called '.wine-wrapped'.
            substituteInPlace $out/lib/perl/CXLog.pm \
              --replace-fail '    $name0 =~ s+^.*/++;' \
                             '    $name0 =~ s+^.*/++; $name0 =~ s/^\.//; $name0 =~ s/-wrapped$//;'

            # Python 3.14 defaults multiprocessing to forkserver, which pickles the
            # worker target; CrossOver's workers hold GTK state and die with
            # "cannot pickle '_thread.lock' object". Force fork back.
            substituteInPlace $out/lib/python/crossoverui.py \
              --replace-fail 'import multiprocessing' \
                             'import multiprocessing
      multiprocessing.set_start_method("fork", force=True)'
            substituteInPlace $out/lib/python/packageview.py \
              --replace-fail 'import multiprocessing' \
                             'import multiprocessing
      multiprocessing.set_start_method("fork", force=True)'

            runHook postInstall
    '';

    # autoPatchelfHook's own pass only patches the 64-bit half of the tree
    # (it matches files against the host ELF class); run it again with the
    # i686 bintools so the bundled 32-bit Wine gets patched too.
    # autoPatchelfLibs is the search path used to resolve DT_NEEDED, normally
    # filled from buildInputs; a subshell keeps the 32-bit addition from
    # leaking into the 64-bit pass above.
    postFixup = ''
      (
        export NIX_BINTOOLS=${pkgsi686Linux.stdenv.cc.bintools}
        autoPatchelfLibs+=(${
          lib.concatMapStringsSep " " (p: "${lib.getLib p}/lib") (runtimeLibs32 ++ compatLibs32)
        })
        autoPatchelf -- "$out"
      )
    '';

    # Via wrapGAppsHook3, not makeWrapperArgs: with __structuredAttrs a
    # makeWrapperArgs bash array reaches makeWrapper unsplit, so the prefix
    # never lands in the wrapper.
    preFixup = ''
      gappsWrapperArgs+=(
        --prefix PATH : "${
          lib.makeBinPath [
            pythonEnv
            openssl.bin
            gzip
            perl
            xdg-utils
          ]
        }"
        --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "${lib.concatStringsSep ":" gstPluginDirs32}"
      )
    '';

    __structuredAttrs = true;
    strictDeps = true;
  };

  darwin = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;

    passthru = {
      inherit updateScript;
    };

    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out/Applications
      cp -R *.app $out/Applications
    '';

    __structuredAttrs = true;
    strictDeps = true;
  };
in
if stdenv.hostPlatform.isDarwin then darwin else linux
