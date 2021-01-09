{ pname, ffversion, meta, updateScript ? null
, src, unpackPhase ? null, patches ? []
, extraNativeBuildInputs ? [], extraConfigureFlags ? [], extraMakeFlags ? [] }:

{ lib, stdenv, pkgconfig, pango, perl, python2, python3, zip
, libjpeg, zlib, dbus, dbus-glib, bzip2, xorg
, freetype, fontconfig, file, nspr, nss, nss_3_53, libnotify
, yasm, libGLU, libGL, sqlite, unzip, makeWrapper
, hunspell, libXdamage, libevent, libstartup_notification
, libvpx_1_8
, icu67, libpng, jemalloc, glib
, autoconf213, which, gnused, rustPackages, rustPackages_1_45
, rust-cbindgen, nodejs, nasm, fetchpatch
, gnum4
, debugBuild ? false

### optionals

## optional libraries

, alsaSupport ? stdenv.isLinux, alsaLib
, pulseaudioSupport ? stdenv.isLinux, libpulseaudio
, ffmpegSupport ? true
, gtk3Support ? true, gtk2, gtk3, wrapGAppsHook
, waylandSupport ? true, libxkbcommon
# LTO is disabled since it caused segfaults on wayland see https://github.com/NixOS/nixpkgs/issues/101429
, ltoSupport ? false, overrideCC, buildPackages
, gssSupport ? true, kerberos
, pipewireSupport ? waylandSupport && webrtcSupport, pipewire

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
}:

assert stdenv.cc.libc or null != null;
assert pipewireSupport -> !waylandSupport || !webrtcSupport -> throw "pipewireSupport requires both wayland and webrtc support.";
assert ltoSupport -> stdenv.isDarwin -> throw "LTO is broken on Darwin (see PR#19312).";

let
  flag = tf: x: [(if tf then "--enable-${x}" else "--disable-${x}")];

  default-toolkit = if stdenv.isDarwin then "cairo-cocoa"
                    else "cairo-gtk${if gtk3Support then "3${lib.optionalString waylandSupport "-wayland"}" else "2"}";

  binaryName = "firefox";
  binaryNameCapitalized = lib.toUpper (lib.substring 0 1 binaryName) + lib.substring 1 (-1) binaryName;

  browserName = if stdenv.isDarwin then binaryNameCapitalized else binaryName;

  execdir = if stdenv.isDarwin
            then "/Applications/${binaryNameCapitalized}.app/Contents/MacOS"
            else "/bin";

  # Darwin's stdenv provides the default llvmPackages version, match that since
  # clang LTO on Darwin is broken so the stdenv is not being changed.
  llvmPackages = if stdenv.isDarwin
                 then buildPackages.llvmPackages
                 else buildPackages.llvmPackages_10;

  # When LTO for Darwin is fixed, the following will need updating as lld
  # doesn't work on it. For now it is fine since ltoSupport implies no Darwin.
  buildStdenv = if ltoSupport
                then overrideCC stdenv llvmPackages.lldClang
                else stdenv;

  # 78 ESR won't build with rustc 1.47
  inherit (if lib.versionAtLeast ffversion "82" then rustPackages else rustPackages_1_45)
    rustc cargo;

  nss_pkg = if lib.versionOlder ffversion "83" then nss_3_53 else nss;
in

buildStdenv.mkDerivation ({
  name = "${pname}-unwrapped-${ffversion}";
  version = ffversion;

  inherit src unpackPhase meta;

  patches = [
    ./env_var_for_system_dir.patch
  ] ++
  lib.optional (lib.versionOlder ffversion "83") ./no-buildconfig-ffx76.patch ++
  lib.optional (lib.versionAtLeast ffversion "84") ./no-buildconfig-ffx84.patch ++

  # there are two flavors of pipewire support
  # The patches for the ESR release and the patches for the current stable
  # release.
  # Until firefox upstream stabilizes pipewire support we will have to continue
  # tracking multiple versions here.
  lib.optional (pipewireSupport && lib.versionOlder ffversion "83")
    (fetchpatch {
      # https://src.fedoraproject.org/rpms/firefox/blob/master/f/firefox-pipewire-0-3.patch
      url = "https://src.fedoraproject.org/rpms/firefox/raw/e99b683a352cf5b2c9ff198756859bae408b5d9d/f/firefox-pipewire-0-3.patch";
      sha256 = "0qc62di5823r7ly2lxkclzj9rhg2z7ms81igz44nv0fzv3dszdab";
    })
    ++
    # This picks pipewire patches from fedora that are part of https://bugzilla.mozilla.org/show_bug.cgi?id=1672944
    lib.optionals (pipewireSupport && lib.versionAtLeast ffversion "83") (let
      fedora_revision = "d6756537dd8cf4d9816dc63ada66ea026e0fd128";
      mkPWPatch = spec: fetchpatch {
        inherit (spec) name sha256;
        url = "https://src.fedoraproject.org/rpms/firefox/raw/${fedora_revision}/f/${spec.name}";
      };
    in map mkPWPatch [
        { name = "pw6.patch"; sha256 = "12lhx9wjpw0ahbfmw07wsx76bb223mr453q9cg8cq951vyskch3s"; }
    ])

  ++ patches;


  # Ignore trivial whitespace changes in patches, this fixes compatibility of
  # ./env_var_for_system_dir.patch with Firefox >=65 without having to track
  # two patches.
  patchFlags = [ "-p1" "-l" ];

  buildInputs = [
    gtk2 perl zip libjpeg zlib bzip2
    dbus dbus-glib pango freetype fontconfig xorg.libXi xorg.libXcursor
    xorg.libX11 xorg.libXrender xorg.libXft xorg.libXt file
    libnotify xorg.pixman yasm libGLU libGL
    xorg.xorgproto
    xorg.libXext unzip makeWrapper
    libevent libstartup_notification /* cairo */
    libpng jemalloc glib
    nasm icu67 libvpx_1_8
    # >= 66 requires nasm for the AV1 lib dav1d
    # yasm can potentially be removed in future versions
    # https://bugzilla.mozilla.org/show_bug.cgi?id=1501796
    # https://groups.google.com/forum/#!msg/mozilla.dev.platform/o-8levmLU80/SM_zQvfzCQAJ
    nspr nss_pkg
  ]
  ++ lib.optional  alsaSupport alsaLib
  ++ lib.optional  pulseaudioSupport libpulseaudio # only headers are needed
  ++ lib.optional  gtk3Support gtk3
  ++ lib.optional  gssSupport kerberos
  ++ lib.optional  ltoSupport llvmPackages.libunwind
  ++ lib.optionals waylandSupport [ libxkbcommon ]
  ++ lib.optionals pipewireSupport [ pipewire ]
  ++ lib.optionals (lib.versionAtLeast ffversion "82") [ gnum4 ]
  ++ lib.optionals buildStdenv.isDarwin [ CoreMedia ExceptionHandling Kerberos
                                          AVFoundation MediaToolbox CoreLocation
                                          Foundation libobjc AddressBook cups ];

  NIX_LDFLAGS = lib.optionalString ltoSupport ''
    -rpath ${placeholder "out"}/lib/${binaryName}
    -rpath ${llvmPackages.libunwind.out}/lib
  '';

  NIX_CFLAGS_COMPILE = toString [
    "-I${glib.dev}/include/gio-unix-2.0"
    "-I${nss_pkg.dev}/include/nss"
  ];

  MACH_USE_SYSTEM_PYTHON = "1";

  postPatch = ''
    rm -rf obj-x86_64-pc-linux-gnu
  '' + lib.optionalString (pipewireSupport && lib.versionOlder ffversion "83") ''
    # substitute the /usr/include/ lines for the libraries that pipewire provides.
    # The patch we pick from fedora only contains the generated moz.build files
    # which hardcode the dependency paths instead of running pkg_config.
    substituteInPlace \
      media/webrtc/trunk/webrtc/modules/desktop_capture/desktop_capture_generic_gn/moz.build \
      --replace /usr/include ${pipewire.dev}/include
  '' + lib.optionalString (lib.versionAtLeast ffversion "80") ''
    substituteInPlace dom/system/IOUtils.h \
      --replace '#include "nspr/prio.h"'          '#include "prio.h"'

    substituteInPlace dom/system/IOUtils.cpp \
      --replace '#include "nspr/prio.h"'          '#include "prio.h"' \
      --replace '#include "nspr/private/pprio.h"' '#include "private/pprio.h"' \
      --replace '#include "nspr/prtypes.h"'       '#include "prtypes.h"'
  '';

  nativeBuildInputs =
    [
      autoconf213
      cargo
      gnused
      llvmPackages.llvm # llvm-objdump
      nodejs
      perl
      pkgconfig
      python2
      python3
      rust-cbindgen
      rustc
      which
    ]
    ++ lib.optional gtk3Support wrapGAppsHook
    ++ lib.optionals buildStdenv.isDarwin [ xcbuild rsync ]
    ++ extraNativeBuildInputs;

  preConfigure = ''
    # remove distributed configuration files
    rm -f configure
    rm -f js/src/configure
    rm -f .mozconfig*
    # this will run autoconf213
    configureScript="$(realpath ./mach) configure"
    export MOZCONFIG=$(pwd)/mozconfig

    # Set C flags for Rust's bindgen program. Unlike ordinary C
    # compilation, bindgen does not invoke $CC directly. Instead it
    # uses LLVM's libclang. To make sure all necessary flags are
    # included we need to look in a few places.
    # TODO: generalize this process for other use-cases.

    BINDGEN_CFLAGS="$(< ${buildStdenv.cc}/nix-support/libc-crt1-cflags) \
      $(< ${buildStdenv.cc}/nix-support/libc-cflags) \
      $(< ${buildStdenv.cc}/nix-support/cc-cflags) \
      $(< ${buildStdenv.cc}/nix-support/libcxx-cxxflags) \
      ${lib.optionalString buildStdenv.cc.isClang "-idirafter ${buildStdenv.cc.cc}/lib/clang/${lib.getVersion buildStdenv.cc.cc}/include"} \
      ${lib.optionalString buildStdenv.cc.isGNU "-isystem ${buildStdenv.cc.cc}/include/c++/${lib.getVersion buildStdenv.cc.cc} -isystem ${buildStdenv.cc.cc}/include/c++/${lib.getVersion buildStdenv.cc.cc}/${buildStdenv.hostPlatform.config}"} \
      $NIX_CFLAGS_COMPILE"

    echo "ac_add_options BINDGEN_CFLAGS='$BINDGEN_CFLAGS'" >> $MOZCONFIG
  '' + (lib.optionalString googleAPISupport ''
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
  '';

  configureFlags = [
    "--enable-application=browser"
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
    "--enable-jemalloc"
    "--enable-default-toolkit=${default-toolkit}"
    "--with-libclang-path=${llvmPackages.libclang}/lib"
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
  ++ lib.optionals ltoSupport [
    "--enable-lto"
    "--disable-elf-hack"
  ] ++ lib.optional (ltoSupport && !buildStdenv.isDarwin) "--enable-linker=lld"

  ++ flag alsaSupport "alsa"
  ++ flag pulseaudioSupport "pulseaudio"
  ++ flag ffmpegSupport "ffmpeg"
  ++ flag gssSupport "negotiateauth"
  ++ flag webrtcSupport "webrtc"
  ++ flag crashreporterSupport "crashreporter"
  ++ lib.optional drmSupport "--enable-eme=widevine"

  ++ (if debugBuild then [ "--enable-debug" "--enable-profiling" ]
                    else [ "--disable-debug" "--enable-release"
                           "--enable-optimize"
                           "--enable-strip" ])
  ++ lib.optional enableOfficialBranding "--enable-official-branding"
  ++ extraConfigureFlags;

  postConfigure = ''
    cd obj-*
  '';

  makeFlags = lib.optionals enableOfficialBranding [
    "MOZILLA_OFFICIAL=1"
    "BUILD_OFFICIAL=1"
  ]
  ++ extraMakeFlags;

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

  postFixup = lib.optionalString buildStdenv.isLinux ''
    # Fix notifications. LibXUL uses dlopen for this, unfortunately; see #18712.
    patchelf --set-rpath "${lib.getLib libnotify
      }/lib:$(patchelf --print-rpath "$out"/lib/${binaryName}*/libxul.so)" \
        "$out"/lib/${binaryName}*/libxul.so
    patchelf --add-needed ${xorg.libXScrnSaver.out}/lib/libXss.so $out/lib/${binaryName}/${binaryName}
    ${lib.optionalString (pipewireSupport && lib.versionAtLeast ffversion "83") ''
      patchelf --add-needed "${lib.getLib pipewire}/lib/libpipewire-0.3.so" \
        "$out"/lib/${binaryName}/${binaryName}
    ''}
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    # Some basic testing
    "$out${execdir}/${browserName}" --version
  '';

  passthru = {
    inherit updateScript;
    version = ffversion;
    isFirefox3Like = true;
    gtk = gtk2;
    inherit alsaSupport;
    inherit nspr;
    inherit ffmpegSupport;
    inherit gssSupport;
    inherit execdir;
    inherit browserName;
  } // lib.optionalAttrs gtk3Support { inherit gtk3; };

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
