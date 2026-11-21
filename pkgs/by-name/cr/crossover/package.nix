{
  addDriverRunpath,
  autoPatchelfHook,
  copyDesktopItems,
  curl,
  fetchurl,
  fetchzip,
  gobject-introspection,
  gst_all_1,
  gzip,
  lib,
  libpcap,
  libpulseaudio,
  makeDesktopItem,
  nix-update,
  openssl,
  perl,
  pkgs,
  pkgsi686Linux,
  python3,
  rpmextract,
  runCommand,
  stdenv,
  writeShellScript,
  wrapGAppsHook3,
  xdg-utils,
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
        hash = "sha256-vtFlMZpT4/sri4TpQkssvGIlyaZTW4qURGTi9/fc8QE=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  meta = {
    description = "Run your Windows® app on MacOS and Linux";
    homepage = "https://www.codeweavers.com/crossover";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    mainProgram = "crossover";
    maintainers = with lib.maintainers; [
      delafthi
      shymega
    ];
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
      curl -sI "https://crossover.codeweavers.com/redirect/$1" \
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
      meta = {
        description = "Stub of the obsolete ISDN CAPI 2.0 library (libcapi20.so.3)";
        license = lib.licenses.mit;
      };
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

  # Wine dlopen()s these rather than linking them, so they carry no
  # DT_NEEDED entry for autoPatchelf to find; appended to the RUNPATH
  # explicitly below, otherwise fonts, audio, GL and printing silently
  # break. Looked up by name through `pkgs`/`pkgsi686Linux` rather than
  # taken as individual function arguments, so the 64-bit and 32-bit
  # (win32 bottle) lists are generated from one list instead of two
  # hand-maintained copies that could drift apart.
  runtimeLibNames = [
    "alsa-lib"
    "cairo"
    "cups"
    "dbus"
    "fontconfig"
    "freetype"
    "gnutls"
    "gtk3"
    "lcms2"
    "libcap"
    "libdrm"
    "libGLU"
    "libgphoto2"
    "libice"
    "libpng"
    "libsm"
    "libunwind"
    "libusb1"
    "libva"
    "libv4l"
    "libx11"
    "libxcomposite"
    "libxcursor"
    "libxext"
    "libxfixes"
    "libxi"
    "libxinerama"
    "libxrandr"
    "libxrender"
    "libxxf86vm"
    "ncurses"
    "ocl-icd"
    "pcsclite"
    "sane-backends"
    "SDL2"
    "udev"
    "unixodbc"
    "vte" # provides Vte-2.91.typelib, needed by the install wizard
    "vulkan-loader"
    "zlib"
  ];

  gstPlugins =
    pkgSet: with pkgSet.gst_all_1; [
      gst-plugins-base
      gst-plugins-good
      gst-plugins-bad
      gst-plugins-ugly
      gst-libav
    ];

  runtimeLibs = [
    libpulseaudio
    openssl
  ]
  ++ map (n: pkgs.${n}) runtimeLibNames
  ++ gstPlugins pkgs;
  runtimeLibs32 = [
    pkgsi686Linux.libpulseaudio
    pkgsi686Linux.openssl
  ]
  ++ map (n: pkgsi686Linux.${n}) runtimeLibNames
  ++ gstPlugins pkgsi686Linux;

  # GStreamer's plugin scanner reads GST_PLUGIN_SYSTEM_PATH_1_0 itself rather
  # than resolving plugins through the linker. wrapGAppsHook3 already
  # captures this var into the wrapper automatically for the 64-bit
  # gst_all_1 plugins in runtimeLibs (its gappsWrapperArgsHook prefixes
  # whatever GST_PLUGIN_SYSTEM_PATH_1_0 is at build time, which their own
  # setup hooks have already populated by then). The 32-bit ones don't go
  # through that, since they're pulled from pkgsi686Linux rather than being
  # real buildInputs, so their dirs have to be stated explicitly here for
  # win32 bottles.
  gstPluginDirs32 = map (p: "${lib.getLib p}/lib/gstreamer-1.0") (gstPlugins pkgsi686Linux);

  linux = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;

    __structuredAttrs = true;
    strictDeps = true;

    nativeBuildInputs = [
      rpmextract
      autoPatchelfHook
      copyDesktopItems
      gobject-introspection
      wrapGAppsHook3
    ];

    desktopItems = [ desktopItem ];

    # perl (the #!/usr/bin/perl launchers) and pythonEnv (the GUI's
    # #!/usr/bin/env python3) are buildInputs, not nativeBuildInputs: these
    # scripts run on the host at runtime, and patchShebangs --host below
    # resolves interpreters from buildInputs, not the build-time PATH.
    buildInputs = runtimeLibs ++ [
      perl
      pythonEnv
    ];

    runtimeDependencies = compatLibs64 ++ compatLibs32;

    appendRunpaths = [
      "${addDriverRunpath.driverLink}/lib"
      # PulseAudio installs libpulsecommon.so.0 into a versioned
      # subdirectory rather than lib/ proper, so the generic runtimeLibs
      # mapping below doesn't reach it; mirrors what upstream Wine does.
      "${lib.getLib libpulseaudio}/lib/pulseaudio"
      "${pkgsi686Linux.libpulseaudio}/lib/pulseaudio"
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

            for size in 16 32 48 64 128 256; do
              mkdir -p $out/share/icons/hicolor/''${size}x''${size}/apps
              cp ./opt/cxoffice/share/icons/''${size}x''${size}/crossover.png \
                $out/share/icons/hicolor/''${size}x''${size}/apps/crossover.png
            done

            # perl launchers have no interpreter on NixOS without this; --host
            # (not --build) because perl/pythonEnv are buildInputs, resolved
            # against the host platform the installed scripts actually run on.
            patchShebangs --host $out

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
        # --prefix, not --append: matches both wrapGAppsHook3's own
        # convention for this variable and upstream Wine's wrapper
        # (pkgs/applications/emulators/wine/base.nix).
        --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "${lib.concatStringsSep ":" gstPluginDirs32}"
      )
    '';

    # autoPatchelfHook's own pass only patches the 64-bit half of the tree
    # (it matches files against the host ELF class); run it again with the
    # i686 bintools so the bundled 32-bit Wine gets patched too.
    # autoPatchelfLibs (filled from buildInputs) isn't writable here, so the
    # 32-bit dirs go through addAutoPatchelfSearchPath instead; a subshell
    # keeps NIX_BINTOOLS from leaking into the 64-bit pass above.
    postFixup = ''
      (
        export NIX_BINTOOLS=${pkgsi686Linux.stdenv.cc.bintools}
        addAutoPatchelfSearchPath ${
          lib.concatMapStringsSep " " (p: "${lib.getLib p}/lib") (runtimeLibs32 ++ compatLibs32)
        }
        autoPatchelf -- "$out"
      )
    '';

    passthru = {
      inherit updateScript;
    };
  };

  darwin = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;

    __structuredAttrs = true;
    strictDeps = true;

    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out/Applications
      cp -R CrossOver.app $out/Applications/

      mkdir -p $out/bin
      ln -s $out/Applications/CrossOver.app/Contents/MacOS/CrossOver $out/bin/crossover
    '';

    passthru = {
      inherit updateScript;
    };
  };
in
if stdenv.hostPlatform.isDarwin then darwin else linux
