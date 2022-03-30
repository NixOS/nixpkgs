{ pname
, version
, meta
, updateScript ? null
, binaryName ? "firefox"
, application ? "browser"
, src
, unpackPhase ? null
, extraPatches ? []
, extraPostPatch ? ""
, extraNativeBuildInputs ? []
, extraConfigureFlags ? []
, extraBuildInputs ? []
, extraMakeFlags ? []
, extraPassthru ? {}
, tests ? []
}:


{ lib
, stdenv
, fetchpatch

# build time
, autoconf
, cargo
, gnused
, makeWrapper
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
, wrapGAppsHook

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
, icu
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
, nss
, pango
, xorg
, zip
, zlib

# optionals

## debugging

, debugBuild ? false

# On 32bit platforms, we disable adding "-g" for easier linking.
, enableDebugSymbols ? !stdenv.is32bit

## optional libraries

, alsaSupport ? stdenv.isLinux, alsa-lib
, ffmpegSupport ? true
, gssSupport ? true, libkrb5
, jemallocSupport ? true, jemalloc
, ltoSupport ? (stdenv.isLinux && stdenv.is64bit), overrideCC, buildPackages
, pgoSupport ? (stdenv.isLinux && stdenv.isx86_64 && stdenv.hostPlatform == stdenv.buildPlatform), xvfb-run
, pipewireSupport ? waylandSupport && webrtcSupport
, pulseaudioSupport ? stdenv.isLinux, libpulseaudio
, waylandSupport ? true, libxkbcommon, libdrm

## privacy-related options

, privacySupport ? false

# WARNING: NEVER set any of the options below to `true` by default.
# Set to `!privacySupport` or `false`.

, geolocationSupport ? !privacySupport
, googleAPISupport ? geolocationSupport
, webrtcSupport ? !privacySupport

# digital rights managemewnt

# This flag controls whether Firefox will show the nagbar, that allows
# users at runtime the choice to enable Widevine CDM support when a site
# requests it.
# Controlling the nagbar and widevine CDM at runtime is possible by setting
# `browser.eme.ui.enabled` and `media.gmp-widevinecdm.enabled` accordingly
, drmSupport ? true

## other

, crashreporterSupport ? false
, safeBrowsingSupport ? false

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
}:

assert stdenv.cc.libc or null != null;
assert pipewireSupport -> !waylandSupport || !webrtcSupport -> throw "${pname}: pipewireSupport requires both wayland and webrtc support.";

let
  flag = tf: x: [(if tf then "--enable-${x}" else "--disable-${x}")];

  # Target the LLVM version that rustc is built with for LTO.
  llvmPackages0 = rustc.llvmPackages;

  # Force the use of lld and other llvm tools for LTO
  llvmPackages = llvmPackages0.override {
    bootBintoolsNoLibc = null;
    bootBintools = null;
  };

  # LTO requires LLVM bintools including ld.lld and llvm-ar.
  buildStdenv = overrideCC llvmPackages.stdenv (llvmPackages.stdenv.cc.override {
    inherit (llvmPackages) bintools;
  });

  # Compile the wasm32 sysroot to build the RLBox Sandbox
  # https://hacks.mozilla.org/2021/12/webassembly-and-back-again-fine-grained-sandboxing-in-firefox-95/
  # We only link c++ libs here, our compiler wrapper can find wasi libc and crt itself.
  wasiSysRoot = runCommand "wasi-sysroot" {} ''
    mkdir -p $out/lib/wasm32-wasi
    for lib in ${pkgsCross.wasi32.llvmPackages.libcxx}/lib/* ${pkgsCross.wasi32.llvmPackages.libcxxabi}/lib/*; do
      ln -s $lib $out/lib/wasm32-wasi
    done
  '';
in

buildStdenv.mkDerivation ({
  name = "${pname}-unwrapped-${version}";
  inherit version;

  inherit src unpackPhase meta;

  # Add another configure-build-profiling run before the final configure phase if we build with pgo
  preConfigurePhases = lib.optionals pgoSupport [
    "configurePhase"
    "buildPhase"
    "profilingPhase"
  ];

  patches = [
    (fetchpatch {
      # RDD Sandbox paths for NixOS, remove with Firefox>=100
      # https://hg.mozilla.org/integration/autoland/rev/5ac6a69a01f47ca050d90704a9791b8224d30f14
      # https://bugzilla.mozilla.org/show_bug.cgi?id=1761692
      name = "mozbz-1761692-rdd-sandbox-paths.patch";
      url = "https://hg.mozilla.org/integration/autoland/raw-rev/5ac6a69a01f47ca050d90704a9791b8224d30f14";
      hash = "sha256-+NGRUxXA7HGvPaAwvDveqRsdXof5nBIc+l4hdf7cC/Y=";
    })
  ]
  ++ lib.optional (lib.versionAtLeast version "86") ./env_var_for_system_dir-ff86.patch
  ++ lib.optional (lib.versionAtLeast version "90" && lib.versionOlder version "95") ./no-buildconfig-ffx90.patch
  ++ lib.optional (lib.versionAtLeast version "96") ./no-buildconfig-ffx96.patch
  ++ extraPatches;

  postPatch = ''
    rm -rf obj-x86_64-pc-linux-gnu
    patchShebangs mach
  ''
  + extraPostPatch;

  # Ignore trivial whitespace changes in patches, this fixes compatibility of
  # ./env_var_for_system_dir.patch with Firefox >=65 without having to track
  # two patches.
  patchFlags = [ "-p1" "-l" ];

  nativeBuildInputs = [
    autoconf
    cargo
    gnused
    llvmPackages.llvm # llvm-objdump
    makeWrapper
    nodejs
    perl
    pkg-config
    python3
    rust-cbindgen
    rustPlatform.bindgenHook
    rustc
    unzip
    which
    wrapGAppsHook
  ]
  ++ lib.optionals pgoSupport [ xvfb-run ]
  ++ extraNativeBuildInputs;

  setOutputFlags = false; # `./mach configure` doesn't understand `--*dir=` flags.

  preConfigure = ''
    # remove distributed configuration files
    rm -f configure js/src/configure .mozconfig*

    # Runs autoconf through ./mach configure in configurePhase
    configureScript="$(realpath ./mach) configure"

    # Set predictable directories for build and state
    export MOZ_OBJDIR=$(pwd)/mozobj
    export MOZBUILD_STATE_PATH=$(pwd)/mozbuild

    # Don't try to send libnotify notifications during build
    export MOZ_NOSPAM=1

    # Set consistent remoting name to ensure wmclass matches with desktop file
    export MOZ_APP_REMOTINGNAME="${binaryName}"

    # Use our own python
    export MACH_USE_SYSTEM_PYTHON=1

    # AS=as in the environment causes build failure
    # https://bugzilla.mozilla.org/show_bug.cgi?id=1497286
    unset AS

  '' + lib.optionalString (lib.versionAtLeast version "95.0") ''
    # RBox WASM Sandboxing
    export WASM_CC=${pkgsCross.wasi32.stdenv.cc}/bin/${pkgsCross.wasi32.stdenv.cc.targetPrefix}cc
    export WASM_CXX=${pkgsCross.wasi32.stdenv.cc}/bin/${pkgsCross.wasi32.stdenv.cc.targetPrefix}c++
 '' + lib.optionalString pgoSupport ''
   if [ -e "$TMPDIR/merged.profdata" ]; then
     echo "Configuring with profiling data"
     for i in "''${!configureFlagsArray[@]}"; do
       if [[ ''${configureFlagsArray[i]} = "--enable-profile-generate=cross" ]]; then
         unset 'configureFlagsArray[i]'
       fi
     done
     configureFlagsArray+=(
       "--enable-profile-use=cross"
       "--with-pgo-profile-path="$TMPDIR/merged.profdata""
       "--with-pgo-jarlog="$TMPDIR/jarlog""
     )
   else
     echo "Configuring to generate profiling data"
     configureFlagsArray+=(
       "--enable-profile-generate=cross"
     )
   fi
  '' + lib.optionalString googleAPISupport ''
    # Google API key used by Chromium and Firefox.
    # Note: These are for NixOS/nixpkgs use ONLY. For your own distribution,
    # please get your own set of keys.
    echo "AIzaSyDGi15Zwl11UNe6Y-5XW_upsfyw31qwZPI" > $TMPDIR/ga
    # 60.5+ & 66+ did split the google API key arguments: https://bugzilla.mozilla.org/show_bug.cgi?id=1531176
    configureFlagsArray+=("--with-google-location-service-api-keyfile=$TMPDIR/ga")
    configureFlagsArray+=("--with-google-safebrowsing-api-keyfile=$TMPDIR/ga")
  '' + lib.optionalString enableOfficialBranding ''
    export MOZILLA_OFFICIAL=1
  '';

  configureFlags = [
    "--disable-tests"
    "--disable-updater"
    "--enable-application=${application}"
    "--enable-default-toolkit=cairo-gtk3${lib.optionalString waylandSupport "-wayland"}"
    "--enable-system-pixman"
    "--with-libclang-path=${llvmPackages.libclang.lib}/lib"
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
  ]
  # LTO is done using clang and lld on Linux.
  ++ lib.optionals ltoSupport [
     "--enable-lto=cross" # Cross-Language LTO
     "--enable-linker=lld"
  ]
  # elf-hack is broken when using clang+lld:
  # https://bugzilla.mozilla.org/show_bug.cgi?id=1482204
  ++ lib.optional (ltoSupport && (buildStdenv.isAarch32 || buildStdenv.isi686 || buildStdenv.isx86_64)) "--disable-elf-hack"
  ++ lib.optional (lib.versionAtLeast version "95") "--with-wasi-sysroot=${wasiSysRoot}"

  ++ flag alsaSupport "alsa"
  ++ flag pulseaudioSupport "pulseaudio"
  ++ flag ffmpegSupport "ffmpeg"
  ++ flag jemallocSupport "jemalloc"
  ++ flag geolocationSupport "necko-wifi"
  ++ flag gssSupport "negotiateauth"
  ++ flag webrtcSupport "webrtc"
  ++ flag crashreporterSupport "crashreporter"
  ++ lib.optional (!drmSupport) "--disable-eme"

  ++ (if debugBuild then [ "--enable-debug" "--enable-profiling" ]
                    else [ "--disable-debug" "--enable-optimize" ])
  # --enable-release adds -ffunction-sections & LTO that require a big amount of
  # RAM and the 32-bit memory space cannot handle that linking
  ++ flag (!debugBuild && !stdenv.is32bit) "release"
  ++ flag enableDebugSymbols "debug-symbols"
  ++ lib.optionals enableDebugSymbols [ "--disable-strip" "--disable-install-strip" ]

  ++ lib.optional enableOfficialBranding "--enable-official-branding"
  ++ extraConfigureFlags;

  buildInputs = [
    bzip2
    dbus
    dbus-glib
    file
    fontconfig
    freetype
    glib
    gnum4
    gtk3
    icu
    libffi
    libGL
    libGLU
    libevent
    libjpeg
    libpng
    libstartup_notification
    libvpx
    libwebp
    nasm
    nspr
    nss
    pango
    perl
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
    zip
    zlib
  ]
  ++ lib.optional  alsaSupport alsa-lib
  ++ lib.optional  pulseaudioSupport libpulseaudio # only headers are needed
  ++ lib.optional  gssSupport libkrb5
  ++ lib.optionals waylandSupport [ libxkbcommon libdrm ]
  ++ lib.optional  jemallocSupport jemalloc
  ++ extraBuildInputs;

  profilingPhase = lib.optionalString pgoSupport ''
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
    cd mozobj
  '';

  postBuild = ''
    cd ..
  '';

  makeFlags = extraMakeFlags;
  separateDebugInfo = enableDebugSymbols;
  enableParallelBuilding = true;

  # tests were disabled in configureFlags
  doCheck = false;

  preInstall = ''
    cd mozobj
  '';

  postInstall = lib.optionalString buildStdenv.isLinux ''
    # Remove SDK cruft. FIXME: move to a separate output?
    rm -rf $out/share/idl $out/include $out/lib/${binaryName}-devel-*

    # Needed to find Mozilla runtime
    gappsWrapperArgs+=(--argv0 "$out/bin/.${binaryName}-wrapped")
  '';

  # Workaround: The separateDebugInfo hook skips artifacts whose build ID's length is not 40.
  # But we got 16-length build ID here. The function body is mainly copied from pkgs/build-support/setup-hooks/separate-debug-info.sh
  # Remove it when https://github.com/NixOS/nixpkgs/pull/146275 is merged.
  preFixup = lib.optionalString enableDebugSymbols ''
    _separateDebugInfo() {
        [ -e "$prefix" ] || return 0

        local dst="''${debug:-$out}"
        if [ "$prefix" = "$dst" ]; then return 0; fi

        dst="$dst/lib/debug/.build-id"

        # Find executables and dynamic libraries.
        local i
        while IFS= read -r -d $'\0' i; do
            if ! isELF "$i"; then continue; fi

            # Extract the Build ID. FIXME: there's probably a cleaner way.
            local id="$($READELF -n "$i" | sed 's/.*Build ID: \([0-9a-f]*\).*/\1/; t; d')"
            if [[ -z "$id" ]]; then
                echo "could not find build ID of $i, skipping" >&2
                continue
            fi

            # Extract the debug info.
            header "separating debug info from $i (build ID $id)"
            mkdir -p "$dst/''${id:0:2}"
            $OBJCOPY --only-keep-debug "$i" "$dst/''${id:0:2}/''${id:2}.debug"
            $STRIP --strip-debug "$i"

            # Also a create a symlink <original-name>.debug.
            ln -sfn ".build-id/''${id:0:2}/''${id:2}.debug" "$dst/../$(basename "$i")"
        done < <(find "$prefix" -type f -print0)
    }
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    # Some basic testing
    "$out/bin/${binaryName}" --version
  '';

  passthru = {
    inherit updateScript;
    inherit version;
    inherit alsaSupport;
    inherit binaryName;
    inherit pipewireSupport;
    inherit nspr;
    inherit ffmpegSupport;
    inherit gssSupport;
    inherit tests;
    inherit gtk3;
    inherit wasiSysRoot;
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
})
