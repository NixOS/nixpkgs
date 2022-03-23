{ pname, version, meta, updateScript ? null
, binaryName ? "firefox", application ? "browser"
, src, unpackPhase ? null, patches ? []
, extraNativeBuildInputs ? [], extraConfigureFlags ? [], extraMakeFlags ? [], tests ? []
, extraPostPatch ? "", extraPassthru ? {} }:

{ lib, stdenv, pkg-config, pango, perl, python3, zip
, libjpeg, zlib, dbus, dbus-glib, bzip2, xorg
, freetype, fontconfig, file, nspr, nss
, yasm, libGLU, libGL, sqlite, unzip, makeWrapper
, hunspell, libevent, libstartup_notification
, libvpx
, icu70, libpng, glib, pciutils
, autoconf213, which, gnused, rustPackages, rustPlatform
, rust-cbindgen, nodejs, nasm, fetchpatch
, gnum4
, gtk3, wrapGAppsHook
, pkgsCross
, debugBuild ? false
, runCommand

### optionals

## optional libraries

, alsaSupport ? stdenv.isLinux, alsa-lib
, pulseaudioSupport ? stdenv.isLinux, libpulseaudio
, ffmpegSupport ? true
, waylandSupport ? true, libxkbcommon, libdrm
, ltoSupport ? (stdenv.isLinux && stdenv.is64bit), overrideCC, buildPackages
, gssSupport ? true, libkrb5
, pipewireSupport ? waylandSupport && webrtcSupport, pipewire
# Jemalloc could reduce memory consumption.
, jemallocSupport ? true, jemalloc

## privacy-related options

, privacySupport ? false

# WARNING: NEVER set any of the options below to `true` by default.
# Set to `!privacySupport` or `false`.

# webrtcSupport breaks the aarch64 build on version >= 60, fixed in 63.
# https://bugzilla.mozilla.org/show_bug.cgi?id=1434589
, webrtcSupport ? !privacySupport
, geolocationSupport ? !privacySupport
, googleAPISupport ? geolocationSupport
, crashreporterSupport ? false

, safeBrowsingSupport ? false
, drmSupport ? false

# macOS dependencies
, xcbuild, CoreMedia, ExceptionHandling, Kerberos, AVFoundation, MediaToolbox
, CoreLocation, Foundation, AddressBook, libobjc, cups, rsync

## other

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

# On 32bit platforms, we disable adding "-g" for easier linking.
, enableDebugSymbols ? !stdenv.is32bit
}:

assert stdenv.cc.libc or null != null;
assert pipewireSupport -> !waylandSupport || !webrtcSupport -> throw "pipewireSupport requires both wayland and webrtc support.";
assert ltoSupport -> stdenv.isDarwin -> throw "LTO is broken on Darwin (see PR#19312).";

let
  flag = tf: x: [(if tf then "--enable-${x}" else "--disable-${x}")];

  default-toolkit = if stdenv.isDarwin then "cairo-cocoa"
                    else "cairo-gtk3${lib.optionalString waylandSupport "-wayland"}";

  binaryNameCapitalized = lib.toUpper (lib.substring 0 1 binaryName) + lib.substring 1 (-1) binaryName;

  applicationName = if stdenv.isDarwin then binaryNameCapitalized else binaryName;

  execdir = if stdenv.isDarwin
            then "/Applications/${binaryNameCapitalized}.app/Contents/MacOS"
            else "/bin";

  inherit (rustPackages) rustc cargo;

  # Darwin's stdenv provides the default llvmPackages version, match that since
  # clang LTO on Darwin is broken so the stdenv is not being changed.
  # Target the LLVM version that rustc -Vv reports it is built with for LTO.
  llvmPackages0 =
    if stdenv.isDarwin
      then buildPackages.llvmPackages
    else rustc.llvmPackages;

  # Force the use of lld and other llvm tools for LTO
  llvmPackages = llvmPackages0.override {
    bootBintoolsNoLibc = null;
    bootBintools = null;
  };

  # When LTO for Darwin is fixed, the following will need updating as lld
  # doesn't work on it. For now it is fine since ltoSupport implies no Darwin.
  buildStdenv = if ltoSupport
                # LTO requires LLVM bintools including ld.lld and llvm-ar.
                then overrideCC llvmPackages.stdenv (llvmPackages.stdenv.cc.override {
                  inherit (llvmPackages) bintools;
                })
                else stdenv;

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

  patches = [
  ] ++
  lib.optional (lib.versionAtLeast version "86") ./env_var_for_system_dir-ff86.patch ++
  lib.optional (lib.versionAtLeast version "90" && lib.versionOlder version "95") ./no-buildconfig-ffx90.patch ++
  lib.optional (lib.versionAtLeast version "96") ./no-buildconfig-ffx96.patch ++

  patches;

  # Ignore trivial whitespace changes in patches, this fixes compatibility of
  # ./env_var_for_system_dir.patch with Firefox >=65 without having to track
  # two patches.
  patchFlags = [ "-p1" "-l" ];

  buildInputs = [
    gnum4 gtk3 perl zip libjpeg zlib bzip2
    dbus dbus-glib pango freetype fontconfig xorg.libXi xorg.libXcursor
    xorg.libX11 xorg.libXrender xorg.libXft xorg.libXt file
    xorg.pixman yasm libGLU libGL
    xorg.xorgproto
    xorg.libXdamage
    xorg.libXext
    xorg.libXtst
    libevent libstartup_notification /* cairo */
    libpng glib
    nasm icu70 libvpx
    # >= 66 requires nasm for the AV1 lib dav1d
    # yasm can potentially be removed in future versions
    # https://bugzilla.mozilla.org/show_bug.cgi?id=1501796
    # https://groups.google.com/forum/#!msg/mozilla.dev.platform/o-8levmLU80/SM_zQvfzCQAJ
    nspr nss
  ]
  ++ lib.optional  alsaSupport alsa-lib
  ++ lib.optional  pulseaudioSupport libpulseaudio # only headers are needed
  ++ lib.optional  gssSupport libkrb5
  ++ lib.optionals waylandSupport [ libxkbcommon libdrm ]
  ++ lib.optional  pipewireSupport pipewire
  ++ lib.optional  jemallocSupport jemalloc
  ++ lib.optionals buildStdenv.isDarwin [ CoreMedia ExceptionHandling Kerberos
                                          AVFoundation MediaToolbox CoreLocation
                                          Foundation libobjc AddressBook cups ];

  MACH_USE_SYSTEM_PYTHON = "1";

  postPatch = ''
    rm -rf obj-x86_64-pc-linux-gnu
    substituteInPlace toolkit/xre/glxtest.cpp \
      --replace 'dlopen("libpci.so' 'dlopen("${pciutils}/lib/libpci.so'

    patchShebangs mach
  '' + extraPostPatch;

  nativeBuildInputs =
    [
      autoconf213
      cargo
      gnused
      llvmPackages.llvm # llvm-objdump
      makeWrapper
      nodejs
      perl
      pkg-config
      python3
      rust-cbindgen
      rustc
      which
      unzip
      wrapGAppsHook
      rustPlatform.bindgenHook
    ]
    ++ lib.optionals buildStdenv.isDarwin [ xcbuild rsync ]
    ++ extraNativeBuildInputs;

  separateDebugInfo = enableDebugSymbols;
  setOutputFlags = false; # `./mach configure` doesn't understand `--*dir=` flags.

  preConfigure = ''
    # remove distributed configuration files
    rm -f configure
    rm -f js/src/configure
    rm -f .mozconfig*
    # this will run autoconf213
    configureScript="$(realpath ./mach) configure"
    export MOZBUILD_STATE_PATH=$(pwd)/mozbuild

  '' + (lib.optionalString (lib.versionAtLeast version "95.0") ''
    # RBox WASM Sandboxing
    export WASM_CC=${pkgsCross.wasi32.stdenv.cc}/bin/${pkgsCross.wasi32.stdenv.cc.targetPrefix}cc
    export WASM_CXX=${pkgsCross.wasi32.stdenv.cc}/bin/${pkgsCross.wasi32.stdenv.cc.targetPrefix}c++
  '') + (lib.optionalString googleAPISupport ''
    # Google API key used by Chromium and Firefox.
    # Note: These are for NixOS/nixpkgs use ONLY. For your own distribution,
    # please get your own set of keys.
    echo "AIzaSyDGi15Zwl11UNe6Y-5XW_upsfyw31qwZPI" > $TMPDIR/ga
    # 60.5+ & 66+ did split the google API key arguments: https://bugzilla.mozilla.org/show_bug.cgi?id=1531176
    configureFlagsArray+=("--with-google-location-service-api-keyfile=$TMPDIR/ga")
    configureFlagsArray+=("--with-google-safebrowsing-api-keyfile=$TMPDIR/ga")
  '') + ''
    # AS=as in the environment causes build failure https://bugzilla.mozilla.org/show_bug.cgi?id=1497286
    unset AS
  '' + (lib.optionalString enableOfficialBranding ''
    export MOZILLA_OFFICIAL=1
    export BUILD_OFFICIAL=1
  '');

  configureFlags = [
    "--enable-application=${application}"
    "--with-system-jpeg"
    "--with-system-zlib"
    "--with-system-libevent"
    "--with-system-libvpx"
    "--with-system-png" # needs APNG support
    "--with-system-icu"
    "--enable-system-ffi"
    "--enable-system-pixman"
    #"--enable-system-cairo"
    "--disable-tests"
    "--disable-necko-wifi" # maybe we want to enable this at some point
    "--disable-updater"
    "--enable-default-toolkit=${default-toolkit}"
    "--with-libclang-path=${llvmPackages.libclang.lib}/lib"
    "--with-system-nspr"
    "--with-system-nss"
  ]
  ++ lib.optional (buildStdenv.isDarwin) "--disable-xcode-checks"
  ++ lib.optional (!ltoSupport) "--with-clang-path=${llvmPackages.clang}/bin/clang"
  # LTO is done using clang and lld on Linux.
  # Darwin needs to use the default linker as lld is not supported (yet?):
  #   https://bugzilla.mozilla.org/show_bug.cgi?id=1538724
  # elf-hack is broken when using clang+lld:
  #   https://bugzilla.mozilla.org/show_bug.cgi?id=1482204
  ++ lib.optional ltoSupport "--enable-lto=cross" # Cross-language LTO.
  ++ lib.optional (ltoSupport && (buildStdenv.isAarch32 || buildStdenv.isi686 || buildStdenv.isx86_64)) "--disable-elf-hack"
  ++ lib.optional (ltoSupport && !buildStdenv.isDarwin) "--enable-linker=lld"
  ++ lib.optional (lib.versionAtLeast version "95") "--with-wasi-sysroot=${wasiSysRoot}"

  ++ flag alsaSupport "alsa"
  ++ flag pulseaudioSupport "pulseaudio"
  ++ flag ffmpegSupport "ffmpeg"
  ++ flag jemallocSupport "jemalloc"
  ++ flag gssSupport "negotiateauth"
  ++ flag webrtcSupport "webrtc"
  ++ flag crashreporterSupport "crashreporter"
  ++ lib.optional drmSupport "--enable-eme=widevine"

  ++ (if debugBuild then [ "--enable-debug" "--enable-profiling" ]
                    else [ "--disable-debug" "--enable-optimize" ])
  # --enable-release adds -ffunction-sections & LTO that require a big amount of
  # RAM and the 32-bit memory space cannot handle that linking
  ++ flag (!debugBuild && !stdenv.is32bit) "release"
  ++ flag enableDebugSymbols "debug-symbols"
  ++ lib.optionals enableDebugSymbols [ "--disable-strip" "--disable-install-strip" ]

  ++ lib.optional enableOfficialBranding "--enable-official-branding"
  ++ extraConfigureFlags;

  postConfigure = ''
    cd obj-*
  '';

  makeFlags = extraMakeFlags;

  enableParallelBuilding = true;
  doCheck = false; # "--disable-tests" above

  installPhase = if buildStdenv.isDarwin then ''
    mkdir -p $out/Applications
    cp -LR dist/${binaryNameCapitalized}.app $out/Applications
  '' else null;

  postInstall = lib.optionalString buildStdenv.isLinux ''
    # Remove SDK cruft. FIXME: move to a separate output?
    rm -rf $out/share/idl $out/include $out/lib/${binaryName}-devel-*

    # Needed to find Mozilla runtime
    gappsWrapperArgs+=(--argv0 "$out/bin/.${binaryName}-wrapped")
  '';

  # Workaround: The separateDebugInfo hook skips artifacts whose build ID's length is not 40.
  # But we got 16-length build ID here. The function body is mainly copied from pkgs/build-support/setup-hooks/separate-debug-info.sh
  # Remove it when PR #146275 is merged.
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
    "$out${execdir}/${applicationName}" --version
  '';

  passthru = {
    inherit updateScript;
    inherit version;
    inherit alsaSupport;
    inherit pipewireSupport;
    inherit nspr;
    inherit ffmpegSupport;
    inherit gssSupport;
    inherit execdir;
    inherit applicationName;
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
