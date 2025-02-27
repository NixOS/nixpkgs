{ pname
, version
, packageVersion ? version
, meta
, updateScript ? null
, binaryName ? "firefox"
, application ? "browser"
, applicationName ? "Firefox"
, branding ? null
, requireSigning ? true
, allowAddonSideload ? false
, src
, unpackPhase ? null
, extraPatches ? []
, extraPostPatch ? ""
, extraNativeBuildInputs ? []
, extraConfigureFlags ? []
, extraBuildInputs ? []
, extraMakeFlags ? []
, extraPassthru ? {}
, tests ? {}
}:

let
  # Specifying --(dis|en)able-elf-hack on a platform for which it's not implemented will give `--disable-elf-hack is not available in this configuration`
  # This is declared here because it's used in the default value of elfhackSupport
  isElfhackPlatform = stdenv: stdenv.hostPlatform.isElf &&
    (stdenv.hostPlatform.isi686 || stdenv.hostPlatform.isx86_64 || stdenv.hostPlatform.isAarch32 || stdenv.hostPlatform.isAarch64);
in

{ lib
, pkgs
, stdenv
, fetchpatch
, patchelf

# build time
, autoconf
, cargo
, dump_syms
, makeWrapper
, mimalloc
, nodejs
, perl
, pkg-config
, pkgsCross # wasm32 rlbox
, python3
, runCommand
, rustc
, rust-cbindgen
, rustPlatform
, unzip
, which
, wrapGAppsHook3

# runtime
, bzip2
, dbus
, dbus-glib
, file
, fontconfig
, freetype
, glib
, gnum4
, gtk3
, icu73
, icu74
, libGL
, libGLU
, libevent
, libffi
, libjpeg
, libpng
, libstartup_notification
, libvpx
, libwebp
, nasm
, nspr
, nss_esr
, nss_latest
, pango
, xorg
, zip
, zlib
, pkgsBuildBuild

# Darwin
, apple-sdk_14
, cups
, rsync # used when preparing .app directory

# optionals

## build
, enableLTO ? (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.is64bit && !stdenv.hostPlatform.isRiscV), overrideCC, buildPackages
, enablePGO ? (stdenv.hostPlatform.isLinux && stdenv.hostPlatform == stdenv.buildPlatform), xvfb-run
, enableElfhack ? isElfhackPlatform stdenv && !(stdenv.hostPlatform.isMusl && stdenv.hostPlatform.isAarch64)

## debugging

, debugBuild ? false

# On 32bit platforms, we disable adding "-g" for easier linking.
, enableDebugSymbols ? !stdenv.hostPlatform.is32bit

## addon signing/sideloading
, enableAddonSideload ? allowAddonSideload
, enableSigningRequirement ? requireSigning

## optional libraries

, withALSA ? stdenv.hostPlatform.isLinux, alsa-lib
, withFFMPEG ? true
, withGSS ? true, libkrb5
, withJACK ? stdenv.hostPlatform.isLinux, libjack2
, withJemalloc ? !stdenv.hostPlatform.isMusl, jemalloc
, withPipewire ? withWayland && enableWebRTC
, withPulseaudio ? stdenv.hostPlatform.isLinux, libpulseaudio
, withSndio ? stdenv.hostPlatform.isLinux, sndio
, withWayland ? !stdenv.hostPlatform.isDarwin, libxkbcommon, libdrm

## privacy

, enableDataReporting ? true
, enableLocation ? true
, enableWebRTC ? true

, enableCrashReporter ? enableDataReporting && !stdenv.hostPlatform.isRiscV && !stdenv.hostPlatform.isMusl, curl

, enableNeckoWiFi ? enableLocation
, enableGoogleAPI ? enableLocation
, enableMLSAPI ? enableLocation

# DRM / Encrypted Media Extensions

# Build time toggle to control whether the DRM nagbar will appear
# (browser.eme.ui.enabled), when sites require it to playback media.
# Controlling the nagbar and widevine CDM at runtime is possible by setting
# `browser.eme.ui.enabled` and `media.gmp-widevinecdm.enabled` accordingly
, enableEMENagbar ? true

# As stated by Sylvestre Ledru (@sylvestre) on Nov 22, 2017 at
# https://github.com/NixOS/nixpkgs/issues/31843#issuecomment-346372756 we
# have permission to use the official firefox branding.
#
# For purposes of documentation the statement of @sylvestre:
# > As the person who did part of the work described in the LWN article
# > and release manager working for Mozilla, I can confirm the statement
# > that I made in
# > https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=815006
# >
# > @garbas shared with me the list of patches applied for the Nix package.
# > As they are just for portability and tiny modifications, they don't
# > alter the experience of the product. In parallel, Rok also shared the
# > build options. They seem good (even if I cannot judge the quality of the
# > packaging of the underlying dependencies like sqlite, png, etc).
# > Therefor, as long as you keep the patch queue sane and you don't alter
# > the experience of Firefox users, you won't have any issues using the
# > official branding.
, enableOfficialBranding ? true
, ...
}@attrs:

assert stdenv.cc.libc or null != null;
assert withPipewire -> !withWayland || !enableWebRTC -> throw "${pname}: pipewireSupport requires both wayland and webrtc support.";
assert enableElfhack -> isElfhackPlatform stdenv;

# removed in 25.05
assert attrs ? privacySupport -> throw "${pname}: The privacySupport option has been replaced and split into `enableDataReporting`, `enableLocation` and `enableWebRTC`.";
assert attrs ? drmSupport -> throw "${pname}: The `drmSupport` attribute has been renamed to `enableEMENagbar` to better reflect its purpose.";

let
  # Don't use official branding with these features disabled
  useOfficialBranding =
    enableOfficialBranding &&
    enableCrashReporter &&
    enableDataReporting &&
    enableGoogleAPI &&
    enableMLSAPI &&
    enableWebRTC
  ;

  inherit (lib) enableFeature;

  # Target the LLVM version that rustc is built with for LTO.
  llvmPackages0 = rustc.llvmPackages;
  llvmPackagesBuildBuild0 = pkgsBuildBuild.rustc.llvmPackages;

  # Force the use of lld and other llvm tools for LTO
  llvmPackages = llvmPackages0.override {
    bootBintoolsNoLibc = null;
    bootBintools = null;
  };
  llvmPackagesBuildBuild = llvmPackagesBuildBuild0.override {
    bootBintoolsNoLibc = null;
    bootBintools = null;
  };

  # LTO requires LLVM bintools including ld.lld and llvm-ar.
  buildStdenv = overrideCC llvmPackages.stdenv (llvmPackages.stdenv.cc.override {
    bintools = if enableLTO then buildPackages.rustc.llvmPackages.bintools else stdenv.cc.bintools;
  });

  # Compile the wasm32 sysroot to build the RLBox Sandbox
  # https://hacks.mozilla.org/2021/12/webassembly-and-back-again-fine-grained-sandboxing-in-firefox-95/
  # We only link c++ libs here, our compiler wrapper can find wasi libc and crt itself.
  wasiSysRoot = runCommand "wasi-sysroot" {} ''
    mkdir -p $out/lib/wasm32-wasi
    for lib in ${pkgsCross.wasi32.llvmPackages.libcxx}/lib/*; do
      ln -s $lib $out/lib/wasm32-wasi
    done
  '';

  distributionIni = let
    platform = if stdenv.hostPlatform.isDarwin then "Nix on MacOS" else "NixOS";
  in
    pkgs.writeText "distribution.ini" (lib.generators.toINI {} {
    # Some light branding indicating this build uses our distro preferences
    Global = {
      id = "nixos";
      version = "1.0";
      about = "${applicationName} for ${platform}";
    };
    Preferences = {
      # These values are exposed through telemetry
      "app.distributor" = "nixos";
      "app.distributor.channel" = "nixpkgs";
    };
  });

  defaultPrefs = {
    "geo.provider.network.url" = {
      value = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
      reason = "Use MLS by default for geolocation, since our Google API Keys are not working";
    };
  };

  defaultPrefsFile = pkgs.writeText "nixos-default-prefs.js" (lib.concatStringsSep "\n" (lib.mapAttrsToList (key: value: ''
    // ${value.reason}
    pref("${key}", ${builtins.toJSON value.value});
  '') defaultPrefs));

  toolkit = if stdenv.hostPlatform.isDarwin then "cairo-cocoa" else "cairo-gtk3${lib.optionalString withWayland "-wayland"}";

in

buildStdenv.mkDerivation {
  pname = "${pname}-unwrapped";
  version = packageVersion;

  inherit src unpackPhase meta;

  outputs = [
    "out"
  ]
  ++ lib.optionals enableCrashReporter [ "symbols" ];

  # Add another configure-build-profiling run before the final configure phase if we build with pgo
  preConfigurePhases = lib.optionals enablePGO [
    "configurePhase"
    "buildPhase"
    "profilingPhase"
  ];

  patches = lib.optionals (lib.versionAtLeast version "111" && lib.versionOlder version "133") [ ./env_var_for_system_dir-ff111.patch ]
  ++ lib.optionals (lib.versionAtLeast version "133") [ ./env_var_for_system_dir-ff133.patch ]
  ++ lib.optionals (lib.versionAtLeast version "121") [ ./no-buildconfig-ffx121.patch ]
  ++ [
    # LLVM 19 turned on WASM reference types by default, exposing a bug
    # that broke the Mozilla WASI build. Supposedly, it has been fixed
    # upstream in LLVM, but the build fails in the same way for us even
    # with LLVM 19 versions that contain the upstream patch.
    #
    # Apply the temporary patch Mozilla used to work around this bug
    # for now until someone can investigate what’s going on here.
    #
    # TODO: Please someone figure out what’s up with this.
    #
    # See: <https://bugzilla.mozilla.org/show_bug.cgi?id=1905251>
    # See: <https://github.com/llvm/llvm-project/pull/97451>
    (fetchpatch {
      name = "wasi-sdk-disable-reference-types.patch";
      url = "https://hg.mozilla.org/integration/autoland/raw-rev/23a9f6555c7c";
      hash = "sha256-CRywalJlRMFVLITEYXxpSq3jLPbUlWKNRHuKLwXqQfU=";
    })
    # Fix for missing vector header on macOS
    # https://bugzilla.mozilla.org/show_bug.cgi?id=1939405
    ./firefox-mac-missing-vector-header.patch
  ]
  ++ extraPatches;

  postPatch = ''
    rm -rf obj-x86_64-pc-linux-gnu
    patchShebangs mach build
  ''
  + extraPostPatch;

  # Ignore trivial whitespace changes in patches, this fixes compatibility of
  # ./env_var_for_system_dir-*.patch with Firefox >=65 without having to track
  # two patches.
  patchFlags = [ "-p1" "-l" ];

  # if not explicitly set, wrong cc from buildStdenv would be used
  HOST_CC = "${llvmPackagesBuildBuild.stdenv.cc}/bin/cc";
  HOST_CXX = "${llvmPackagesBuildBuild.stdenv.cc}/bin/c++";

  nativeBuildInputs = [
    autoconf
    cargo
    gnum4
    llvmPackagesBuildBuild.bintools
    makeWrapper
    nodejs
    perl
    python3
    rust-cbindgen
    rustPlatform.bindgenHook
    rustc
    unzip
    which
    wrapGAppsHook3
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ pkg-config ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ rsync ]
  ++ lib.optionals enableCrashReporter [ dump_syms patchelf ]
  ++ lib.optionals enablePGO [ xvfb-run ]
  ++ extraNativeBuildInputs;

  setOutputFlags = false; # `./mach configure` doesn't understand `--*dir=` flags.

  preConfigure = ''
    # Runs autoconf through ./mach configure in configurePhase
    configureScript="$(realpath ./mach) configure"

    # Set reproducible build date; https://bugzilla.mozilla.org/show_bug.cgi?id=885777#c21
    export MOZ_BUILD_DATE=$(head -n1 sourcestamp.txt)

    # Set predictable directories for build and state
    export MOZ_OBJDIR=$(pwd)/objdir
    export MOZBUILD_STATE_PATH=$TMPDIR/mozbuild

    # Optionally deconfigure features that submit data
    ${lib.optionalString (!enableDataReporting)
      "export MOZ_DATA_REPORTING=0"}

    # Don't try to send libnotify notifications during build
    export MOZ_NOSPAM=1

    # Set consistent remoting name to ensure wmclass matches with desktop file
    export MOZ_APP_REMOTINGNAME="${binaryName}"

    # AS=as in the environment causes build failure
    # https://bugzilla.mozilla.org/show_bug.cgi?id=1497286
    unset AS

    # Use our own python
    export MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE=system

    # RBox WASM Sandboxing
    export WASM_CC=${pkgsCross.wasi32.stdenv.cc}/bin/${pkgsCross.wasi32.stdenv.cc.targetPrefix}cc
    export WASM_CXX=${pkgsCross.wasi32.stdenv.cc}/bin/${pkgsCross.wasi32.stdenv.cc.targetPrefix}c++
  '' + lib.optionalString enablePGO ''
    if [ -e "$TMPDIR/merged.profdata" ]; then
      echo "Configuring with profiling data"
      for i in "''${!configureFlagsArray[@]}"; do
        if [[ ''${configureFlagsArray[i]} = "--enable-profile-generate=cross" ]]; then
          unset 'configureFlagsArray[i]'
        fi
      done
      appendToVar configureFlags --enable-profile-use=cross
      appendToVar configureFlags --with-pgo-profile-path=$TMPDIR/merged.profdata
      appendToVar configureFlags --with-pgo-jarlog=$TMPDIR/jarlog
      ${lib.optionalString stdenv.hostPlatform.isMusl ''
        LDFLAGS="$OLD_LDFLAGS"
        unset OLD_LDFLAGS
      ''}
    else
      echo "Configuring to generate profiling data"
      configureFlagsArray+=(
        "--enable-profile-generate=cross"
      )
      ${lib.optionalString stdenv.hostPlatform.isMusl
      # Set the rpath appropriately for the profiling run
      # During the profiling run, loading libraries from $out would fail,
      # since the profiling build has not been installed to $out
      ''
        OLD_LDFLAGS="$LDFLAGS"
        LDFLAGS="-Wl,-rpath,$(pwd)/objdir/dist/${binaryName}"
      ''}
    fi
  '' + lib.optionalString enableGoogleAPI ''
    # Google API key used by Chromium and Firefox.
    # Note: These are for NixOS/nixpkgs use ONLY. For your own distribution,
    # please get your own set of keys at https://www.chromium.org/developers/how-tos/api-keys/.
    echo "AIzaSyDGi15Zwl11UNe6Y-5XW_upsfyw31qwZPI" > $TMPDIR/google-api-key
    # 60.5+ & 66+ did split the google API key arguments: https://bugzilla.mozilla.org/show_bug.cgi?id=1531176
    configureFlagsArray+=("--with-google-location-service-api-keyfile=$TMPDIR/google-api-key")
    configureFlagsArray+=("--with-google-safebrowsing-api-keyfile=$TMPDIR/google-api-key")
  '' + lib.optionalString enableMLSAPI ''
    # Mozilla Location services API key
    # Note: These are for NixOS/nixpkgs use ONLY. For your own distribution,
    # please get your own set of keys at https://location.services.mozilla.com/api.
    echo "dfd7836c-d458-4917-98bb-421c82d3c8a0" > $TMPDIR/mls-api-key
    configureFlagsArray+=("--with-mozilla-api-keyfile=$TMPDIR/mls-api-key")
  '' + lib.optionalString (useOfficialBranding && !stdenv.hostPlatform.is32bit) ''
    export MOZILLA_OFFICIAL=1
  '' + lib.optionalString (!enableSigningRequirement) ''
    export MOZ_REQUIRE_SIGNING=
  '' + lib.optionalString stdenv.hostPlatform.isMusl ''
    # linking firefox hits the vm.max_map_count kernel limit with the default musl allocator
    # TODO: Default vm.max_map_count has been increased, retest without this
    export LD_PRELOAD=${mimalloc}/lib/libmimalloc.so
  '';

  # firefox has a different definition of configurePlatforms from nixpkgs, see configureFlags
  configurePlatforms = [ ];

  configureFlags = [
    "--disable-tests"
    "--disable-updater"
    "--enable-application=${application}"
    "--enable-default-toolkit=${toolkit}"
    "--with-app-name=${binaryName}"
    "--with-distribution-id=org.nixos"
    "--with-libclang-path=${lib.getLib llvmPackagesBuildBuild.libclang}/lib"
    "--with-wasi-sysroot=${wasiSysRoot}"
    # for firefox, host is buildPlatform, target is hostPlatform
    "--host=${buildStdenv.buildPlatform.config}"
    "--target=${buildStdenv.hostPlatform.config}"
  ]
  # LTO is done using clang and lld on Linux.
  ++ lib.optionals enableLTO [
     "--enable-lto=cross,full" # Cross-Language LTO
     "--enable-linker=lld"
  ]
  ++ lib.optional (isElfhackPlatform stdenv) (enableFeature enableElfhack "elf-hack")
  ++ lib.optional (!enableEMENagbar) "--disable-eme"
  ++ lib.optional enableAddonSideload "--allow-addon-sideload"
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    # MacOS builds use bundled versions of libraries: https://bugzilla.mozilla.org/show_bug.cgi?id=1776255
    "--enable-system-pixman"
    "--with-system-ffi"
    "--with-system-icu"
    "--with-system-jpeg"
    "--with-system-libevent"
    "--with-system-libvpx"
    "--with-system-nspr"
    "--with-system-nss"
    "--with-system-png" # needs APNG support
    "--with-system-webp"
    "--with-system-zlib"

    # These options are not available on MacOS, even --disable-*
    (enableFeature withALSA "alsa")
    (enableFeature withJACK "jack")
    (enableFeature withPulseaudio "pulseaudio")
    (enableFeature withSndio "sndio")
  ]
  ++ [
    (enableFeature enableCrashReporter "crashreporter")
    (enableFeature withFFMPEG "ffmpeg")
    (enableFeature enableNeckoWiFi "necko-wifi")
    (enableFeature withGSS "negotiateauth")
    (enableFeature withJemalloc "jemalloc")
    (enableFeature enableWebRTC "webrtc")

    (enableFeature debugBuild "debug")
    (if debugBuild then "--enable-profiling" else "--enable-optimize")
    # --enable-release adds -ffunction-sections & LTO that require a big amount
    # of RAM, and the 32-bit memory space cannot handle that linking
    (enableFeature (!debugBuild && !stdenv.hostPlatform.is32bit) "release")
    (enableFeature enableDebugSymbols "debug-symbols")
  ]
  ++ lib.optionals enableDebugSymbols [ "--disable-strip" "--disable-install-strip" ]
  ++ lib.optionals useOfficialBranding [ "--enable-official-branding" ]
  ++ lib.optional (branding != null) "--with-branding=${branding}"
  ++ extraConfigureFlags;

  buildInputs = [
    bzip2
    file
    libGL
    libGLU
    libstartup_notification
    nasm
    perl
    zip
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_14
    cups
  ]
  ++ (lib.optionals (!stdenv.hostPlatform.isDarwin) ([
    dbus
    dbus-glib
    fontconfig
    freetype
    glib
    gtk3
    libffi
    libevent
    libjpeg
    libpng
    libvpx
    libwebp
    nspr
    pango
    xorg.libX11
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXft
    xorg.libXi
    xorg.libXrender
    xorg.libXt
    xorg.libXtst
    xorg.pixman
    xorg.xorgproto
    zlib
    (if (lib.versionAtLeast version "116") then nss_latest else nss_esr/*3.90*/)
  ] ++ lib.optional  withALSA alsa-lib
    ++ lib.optional  withJACK libjack2
    ++ lib.optional  withPulseaudio libpulseaudio # only headers are needed
    ++ lib.optional  withSndio sndio
    ++ lib.optionals withWayland [ libxkbcommon libdrm ]
  ))
  # icu74 fails to build on 127 and older
  # https://bugzilla.mozilla.org/show_bug.cgi?id=1862601
  ++ [ (if (lib.versionAtLeast version "134") then icu74 else icu73) ]
  ++ lib.optional  withGSS libkrb5
  ++ lib.optional  withJemalloc jemalloc
  ++ extraBuildInputs;

  profilingPhase = lib.optionalString enablePGO ''
    # Package up Firefox for profiling
    ./mach package

    # Run profiling
    (
      export HOME=$TMPDIR
      export LLVM_PROFDATA=llvm-profdata
      export JARLOG_FILE="$TMPDIR/jarlog"

      xvfb-run -w 10 -s "-screen 0 1920x1080x24" \
        ./mach python ./build/pgo/profileserver.py
    )

    # Copy profiling data to a place we can easily reference
    cp ./merged.profdata $TMPDIR/merged.profdata

    # Clean build dir
    ./mach clobber
  '';

  preBuild = ''
    cd objdir
  '';

  postBuild = ''
    cd ..
  '';

  makeFlags = extraMakeFlags;
  separateDebugInfo = enableDebugSymbols;
  enableParallelBuilding = true;
  env = lib.optionalAttrs stdenv.hostPlatform.isMusl {
    # Firefox relies on nonstandard behavior of the glibc dynamic linker. It re-uses
    # previously loaded libraries even though they are not in the rpath of the newly loaded binary.
    # On musl we have to explicitly set the rpath to include these libraries.
    LDFLAGS = "-Wl,-rpath,${placeholder "out"}/lib/${binaryName}";
  };

  # tests were disabled in configureFlags
  doCheck = false;

  # Generate build symbols once after the final build
  # https://firefox-source-docs.mozilla.org/crash-reporting/uploading_symbol.html
  preInstall = lib.optionalString enableCrashReporter ''
    ./mach buildsymbols
    mkdir -p $symbols/
    cp objdir/dist/*.crashreporter-symbols.zip $symbols/
  '' + ''
    cd objdir
  '';

  # The target will prepare .app bundle
  installTargets = lib.optionalString stdenv.hostPlatform.isDarwin "stage-package";

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    cp -r dist/${binaryName}/*.app "$out/Applications/${applicationName}.app"

    resourceDir="$out/Applications/${applicationName}.app/Contents/Resources"

  '' + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    # Remove SDK cruft. FIXME: move to a separate output?
    rm -rf $out/share/idl $out/include $out/lib/${binaryName}-devel-*

    # Needed to find Mozilla runtime
    gappsWrapperArgs+=(--argv0 "$out/bin/.${binaryName}-wrapped")

    resourceDir=$out/lib/${binaryName}
  '' + ''
    # Install distribution customizations
    install -Dvm644 ${distributionIni} "$resourceDir/distribution/distribution.ini"
    install -Dvm644 ${defaultPrefsFile} "$resourceDir/browser/defaults/preferences/nixos-default-prefs.js"

    cd ..
  '';

  postFixup = lib.optionalString (enableCrashReporter && buildStdenv.hostPlatform.isLinux) ''
    patchelf --add-rpath "${lib.makeLibraryPath [ curl ]}" $out/lib/${binaryName}/crashreporter
  '';

  # Some basic testing
  doInstallCheck = true;
  installCheckPhase = lib.optionalString buildStdenv.hostPlatform.isDarwin ''
    bindir="$out/Applications/${applicationName}.app/Contents/MacOS"
  '' + lib.optionalString (!buildStdenv.hostPlatform.isDarwin) ''
    bindir=$out/bin
  '' + ''
    "$bindir/${binaryName}" --version
  '';

  passthru = {
    inherit applicationName;
    inherit application extraPatches;
    inherit updateScript;
    inherit withALSA;
    inherit binaryName;
    inherit enableSigningRequirement enableAddonSideload;
    inherit withJACK;
    inherit withPipewire;
    inherit withSndio;
    inherit nspr;
    inherit withFFMPEG;
    inherit withGSS;
    inherit tests;
    inherit gtk3;
    inherit wasiSysRoot;
    inherit useOfficialBranding;
    version = packageVersion;
  } // extraPassthru;

  hardeningDisable = [ "format" ]; # -Werror=format-security

  # the build system verifies checksums of the bundled rust sources
  # ./third_party/rust is be patched by our libtool fixup code in stdenv
  # unfortunately we can't just set this to `false` when we do not want it.
  # See https://github.com/NixOS/nixpkgs/issues/77289 for more details
  # Ideally we would figure out how to tell the build system to not
  # care about changed hashes as we are already doing that when we
  # fetch the sources. Any further modifications of the source tree
  # is on purpose by some of our tool (or by accident and a bug?).
  dontFixLibtool = true;

  # on aarch64 this is also required
  dontUpdateAutotoolsGnuConfigScripts = true;

  requiredSystemFeatures = [ "big-parallel" ];
}
