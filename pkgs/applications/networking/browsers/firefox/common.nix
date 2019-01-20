{ pname, ffversion, meta, updateScript ? null
, src, unpackPhase ? null, patches ? []
, extraNativeBuildInputs ? [], extraConfigureFlags ? [], extraMakeFlags ? []
, isTorBrowserLike ? false, tbversion ? null }:

{ lib, stdenv, pkgconfig, pango, perl, python2, zip, libIDL
, libjpeg, zlib, dbus, dbus-glib, bzip2, xorg
, freetype, fontconfig, file, nspr, nss, libnotify
, yasm, libGLU_combined, sqlite, unzip, makeWrapper
, hunspell, libevent, libstartup_notification, libvpx
, icu, libpng, jemalloc, glib
, autoconf213, which, gnused, cargo, rustc, llvmPackages
, rust-cbindgen, nodejs
, debugBuild ? false

### optionals

## optional libraries

, alsaSupport ? stdenv.isLinux, alsaLib
, pulseaudioSupport ? stdenv.isLinux, libpulseaudio
, ffmpegSupport ? true
, gtk3Support ? true, gtk2, gtk3, wrapGAppsHook
, gssSupport ? true, kerberos

## privacy-related options

, privacySupport ? isTorBrowserLike

# WARNING: NEVER set any of the options below to `true` by default.
# Set to `privacySupport` or `false`.

# webrtcSupport breaks the aarch64 build on version >= 60.
# https://bugzilla.mozilla.org/show_bug.cgi?id=1434589
, webrtcSupport ? (if lib.versionAtLeast ffversion "60" && stdenv.isAarch64 then false else !privacySupport)
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
# Fur purposes of documentation the statement of @sylvestre:
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

let
  flag = tf: x: [(if tf then "--enable-${x}" else "--disable-${x}")];

  default-toolkit = if stdenv.isDarwin then "cairo-cocoa"
                    else "cairo-gtk${if gtk3Support then "3" else "2"}";

  execdir = if stdenv.isDarwin
            then "/Applications/${browserName}.app/Contents/MacOS"
            else "/bin";
  browserName = if stdenv.isDarwin then "Firefox" else "firefox";
in

stdenv.mkDerivation rec {
  name = "${pname}-unwrapped-${version}";
  version = if !isTorBrowserLike then ffversion else tbversion;

  inherit src unpackPhase patches meta;

  buildInputs = [
    gtk2 perl zip libIDL libjpeg zlib bzip2
    dbus dbus-glib pango freetype fontconfig xorg.libXi xorg.libXcursor
    xorg.libX11 xorg.libXrender xorg.libXft xorg.libXt file
    libnotify xorg.pixman yasm libGLU_combined
    xorg.libXScrnSaver xorg.xorgproto
    xorg.libXext sqlite unzip makeWrapper
    libevent libstartup_notification libvpx /* cairo */
    icu libpng jemalloc glib
  ]
  ++ lib.optionals (!isTorBrowserLike) [ nspr nss ]
  ++ lib.optional (lib.versionOlder ffversion "61") hunspell
  ++ lib.optional  alsaSupport alsaLib
  ++ lib.optional  pulseaudioSupport libpulseaudio # only headers are needed
  ++ lib.optional  gtk3Support gtk3
  ++ lib.optional  gssSupport kerberos
  ++ lib.optionals stdenv.isDarwin [ CoreMedia ExceptionHandling Kerberos
                                     AVFoundation MediaToolbox CoreLocation
                                     Foundation libobjc AddressBook cups ];

  NIX_CFLAGS_COMPILE = [
    "-I${glib.dev}/include/gio-unix-2.0"
  ]
  ++ lib.optionals (!isTorBrowserLike) [
    "-I${nss.dev}/include/nss"
  ]
  ++ lib.optional stdenv.isDarwin [
    "-isystem ${llvmPackages.libcxx}/include/c++/v1"
    "-DMAC_OS_X_VERSION_MAX_ALLOWED=MAC_OS_X_VERSION_10_10"
  ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace js/src/jsmath.cpp --replace 'defined(HAVE___SINCOS)' 0
  '' + lib.optionalString (lib.versionAtLeast ffversion "63.0" && !isTorBrowserLike) ''
    substituteInPlace third_party/prio/prio/rand.c --replace 'nspr/prinit.h' 'prinit.h'
  '';

  nativeBuildInputs =
    [ autoconf213 which gnused pkgconfig perl python2 cargo rustc ]
    ++ lib.optional gtk3Support wrapGAppsHook
    ++ lib.optionals stdenv.isDarwin [ xcbuild rsync ]
    ++ lib.optionals (lib.versionAtLeast ffversion "63.0") [ rust-cbindgen nodejs ]
    ++ extraNativeBuildInputs;

  preConfigure = ''
    # remove distributed configuration files
    rm -f configure
    rm -f js/src/configure
    rm -f .mozconfig*
  '' + (if lib.versionAtLeast ffversion "58"
  # this will run autoconf213
  then ''
    configureScript="$(realpath ./mach) configure"
  '' else ''
    make -f client.mk configure-files
    configureScript="$(realpath ./configure)"
  '') + lib.optionalString (lib.versionAtLeast ffversion "53") ''
    export MOZCONFIG=$(pwd)/mozconfig

    # Set C flags for Rust's bindgen program. Unlike ordinary C
    # compilation, bindgen does not invoke $CC directly. Instead it
    # uses LLVM's libclang. To make sure all necessary flags are
    # included we need to look in a few places.
    # TODO: generalize this process for other use-cases.

    BINDGEN_CFLAGS="$(< ${stdenv.cc}/nix-support/libc-cflags) \
      $(< ${stdenv.cc}/nix-support/cc-cflags) \
      ${stdenv.cc.default_cxx_stdlib_compile} \
      ${lib.optionalString stdenv.cc.isClang "-idirafter ${stdenv.cc.cc}/lib/clang/${lib.getVersion stdenv.cc.cc}/include"} \
      ${lib.optionalString stdenv.cc.isGNU "-isystem ${stdenv.cc.cc}/include/c++/${lib.getVersion stdenv.cc.cc} -isystem ${stdenv.cc.cc}/include/c++/${lib.getVersion stdenv.cc.cc}/$(cc -dumpmachine)"} \
      $NIX_CFLAGS_COMPILE"

    echo "ac_add_options BINDGEN_CFLAGS='$BINDGEN_CFLAGS'" >> $MOZCONFIG
  '' + lib.optionalString googleAPISupport ''
    # Google API key used by Chromium and Firefox.
    # Note: These are for NixOS/nixpkgs use ONLY. For your own distribution,
    # please get your own set of keys.
    echo "AIzaSyDGi15Zwl11UNe6Y-5XW_upsfyw31qwZPI" > $TMPDIR/ga
    configureFlagsArray+=("--with-google-api-keyfile=$TMPDIR/ga")
  '' + lib.optionalString (lib.versionOlder ffversion "58") ''
    cd obj-*
  ''
  # AS=as in the environment causes build failure https://bugzilla.mozilla.org/show_bug.cgi?id=1497286
  + lib.optionalString (lib.versionAtLeast ffversion "64") ''
    unset AS
  '';

  configureFlags = [
    "--enable-application=browser"
    "--with-system-jpeg"
    "--with-system-zlib"
    "--with-system-bz2"
    "--with-system-libevent"
    "--with-system-libvpx"
    "--with-system-png" # needs APNG support
    "--with-system-icu"
    "--enable-system-ffi"
    "--enable-system-pixman"
    "--enable-system-sqlite"
    #"--enable-system-cairo"
    "--enable-startup-notification"
    #"--enable-content-sandbox" # TODO: probably enable after 54
    "--disable-tests"
    "--disable-necko-wifi" # maybe we want to enable this at some point
    "--disable-updater"
    "--enable-jemalloc"
    "--disable-gconf"
    "--enable-default-toolkit=${default-toolkit}"
  ]
  ++ lib.optional (lib.versionOlder ffversion "64") "--disable-maintenance-service"
  ++ lib.optional (stdenv.isDarwin && lib.versionAtLeast ffversion "61") "--disable-xcode-checks"
  ++ lib.optional (lib.versionOlder ffversion "61") "--enable-system-hunspell"
  ++ lib.optionals (lib.versionAtLeast ffversion "56") [
    "--with-libclang-path=${llvmPackages.libclang}/lib"
    "--with-clang-path=${llvmPackages.clang}/bin/clang"
  ]
  ++ lib.optionals (lib.versionAtLeast ffversion "57") [
    "--enable-webrender=build"
  ]

  # TorBrowser patches these
  ++ lib.optionals (!isTorBrowserLike) [
    "--with-system-nspr"
    "--with-system-nss"
  ]

  # and wants these
  ++ lib.optionals isTorBrowserLike ([
    "--with-tor-browser-version=${tbversion}"
    "--enable-signmar"
    "--enable-verify-mar"
  ])

  ++ flag alsaSupport "alsa"
  ++ flag pulseaudioSupport "pulseaudio"
  ++ flag ffmpegSupport "ffmpeg"
  ++ flag gssSupport "negotiateauth"
  ++ flag webrtcSupport "webrtc"
  ++ flag crashreporterSupport "crashreporter"
  ++ lib.optional drmSupport "--enable-eme=widevine"

  ++ lib.optionals (lib.versionOlder ffversion "60") ([]
    ++ flag geolocationSupport "mozril-geoloc"
    ++ flag safeBrowsingSupport "safe-browsing"
  )

  ++ (if debugBuild then [ "--enable-debug" "--enable-profiling" ]
                    else [ "--disable-debug" "--enable-release"
                           "--enable-optimize"
                           "--enable-strip" ])
  ++ lib.optional enableOfficialBranding "--enable-official-branding"
  ++ extraConfigureFlags;

  # Before 58 we have to run `make -f client.mk configure-files` at
  # the top level, and then run `./configure` in the obj-* dir (see
  # above), but in 58 we have to instead run `./mach configure` at the
  # top level and then run `make` in obj-*. (We can also run the
  # `make` at the top level in 58, but then we would have to `cd` to
  # `make install` anyway. This is ugly, but simple.)
  postConfigure = lib.optionalString (lib.versionAtLeast ffversion "58") ''
    cd obj-*
  '';

  preBuild = lib.optionalString isTorBrowserLike ''
    buildFlagsArray=("MOZ_APP_DISPLAYNAME=Tor Browser")
  '';

  makeFlags = lib.optionals enableOfficialBranding [
    "MOZILLA_OFFICIAL=1"
    "BUILD_OFFICIAL=1"
  ]
  ++ extraMakeFlags;

  enableParallelBuilding = true;
  doCheck = false; # "--disable-tests" above

  installPhase = if stdenv.isDarwin then ''
    mkdir -p $out/Applications
    cp -LR dist/Firefox.app $out/Applications
  '' else null;

  postInstall = lib.optionalString stdenv.isLinux ''
    # Remove SDK cruft. FIXME: move to a separate output?
    rm -rf $out/share/idl $out/include $out/lib/firefox-devel-*

    # Needed to find Mozilla runtime
    gappsWrapperArgs+=(--argv0 "$out/bin/.firefox-wrapped")
  '';

  postFixup = lib.optionalString stdenv.isLinux ''
    # Fix notifications. LibXUL uses dlopen for this, unfortunately; see #18712.
    patchelf --set-rpath "${lib.getLib libnotify
      }/lib:$(patchelf --print-rpath "$out"/lib/firefox*/libxul.so)" \
        "$out"/lib/firefox*/libxul.so
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    # Some basic testing
    "$out${execdir}/${browserName}" --version
  '';

  passthru = {
    inherit version updateScript;
    isFirefox3Like = true;
    inherit isTorBrowserLike;
    gtk = gtk2;
    inherit nspr;
    inherit ffmpegSupport;
    inherit gssSupport;
    inherit execdir;
    inherit browserName;
  } // lib.optionalAttrs gtk3Support { inherit gtk3; };

}
