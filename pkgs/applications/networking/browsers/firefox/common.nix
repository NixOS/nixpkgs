{ pname, version, updateScript ? null
, src, patches ? [], extraConfigureFlags ? [], extraMakeFlags ? [], overrides ? {}, meta
, isTorBrowserLike ? false }:

{ lib, stdenv, pkgconfig, pango, perl, python, zip, libIDL
, libjpeg, zlib, dbus, dbus-glib, bzip2, xorg
, freetype, fontconfig, file, nspr, nss, libnotify
, yasm, mesa, sqlite, unzip, makeWrapper
, hunspell, libevent, libstartup_notification, libvpx
, cairo, icu, libpng, jemalloc
, autoconf213, which, gnused, cargo, rustc, llvmPackages
, debugBuild ? false

### optionals

## optional libraries

, alsaSupport ? true, alsaLib
, pulseaudioSupport ? true, libpulseaudio
, ffmpegSupport ? true, gstreamer, gst-plugins-base
, gtk3Support ? !isTorBrowserLike, gtk2, gtk3, wrapGAppsHook
, gssSupport ? true, kerberos

## privacy-related options

, privacySupport ? isTorBrowserLike

# WARNING: NEVER set any of the options below to `true` by default.
# Set to `privacySupport` or `false`.

, webrtcSupport ? !privacySupport
, geolocationSupport ? !privacySupport
, googleAPISupport ? geolocationSupport
, crashreporterSupport ? false

, safeBrowsingSupport ? false
, drmSupport ? false

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
  gcc = if stdenv.cc.isGNU then stdenv.cc.cc else stdenv.cc.cc.gcc;
in

stdenv.mkDerivation (rec {
  name = "${pname}-unwrapped-${version}";

  inherit src patches meta;

  buildInputs = [
    gtk2 perl zip libIDL libjpeg zlib bzip2
    dbus dbus-glib pango freetype fontconfig xorg.libXi
    xorg.libX11 xorg.libXrender xorg.libXft xorg.libXt file
    nspr libnotify xorg.pixman yasm mesa
    xorg.libXScrnSaver xorg.scrnsaverproto
    xorg.libXext xorg.xextproto sqlite unzip makeWrapper
    hunspell libevent libstartup_notification libvpx /* cairo */
    icu libpng jemalloc
  ]
  ++ lib.optionals (!isTorBrowserLike) [ nss ]

  ++ lib.optional  alsaSupport alsaLib
  ++ lib.optional  pulseaudioSupport libpulseaudio # only headers are needed
  ++ lib.optionals ffmpegSupport [ gstreamer gst-plugins-base ]
  ++ lib.optional  gtk3Support gtk3
  ++ lib.optional  gssSupport kerberos;

  NIX_CFLAGS_COMPILE = "-I${nspr.dev}/include/nspr -I${nss.dev}/include/nss";

  nativeBuildInputs =
    [ autoconf213 which gnused pkgconfig perl python cargo rustc ]
    ++ lib.optional gtk3Support wrapGAppsHook;

  preConfigure = ''
    # remove distributed configuration files
    rm -f configure
    rm -f js/src/configure
    rm -f .mozconfig*
  '' + (if lib.versionAtLeast version "58"
  # this will run autoconf213
  then ''
    configureScript="$(realpath ./mach) configure"
  '' else ''
    make -f client.mk configure-files
    configureScript="$(realpath ./configure)"
  '') + ''
    cxxLib=$( echo -n ${gcc}/include/c++/* )
    archLib=$cxxLib/$( ${gcc}/bin/gcc -dumpmachine )

    test -f layout/style/ServoBindings.toml && sed -i -e '/"-DMOZ_STYLO"/ a , "-cxx-isystem", "'$cxxLib'", "-isystem", "'$archLib'"' layout/style/ServoBindings.toml
  '' + lib.optionalString googleAPISupport ''
    # Google API key used by Chromium and Firefox.
    # Note: These are for NixOS/nixpkgs use ONLY. For your own distribution,
    # please get your own set of keys.
    echo "AIzaSyDGi15Zwl11UNe6Y-5XW_upsfyw31qwZPI" > $TMPDIR/ga
    configureFlagsArray+=("--with-google-api-keyfile=$TMPDIR/ga")
  '' + lib.optionalString (lib.versionOlder version "58") ''
    cd obj-*
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
    "--enable-system-hunspell"
    "--enable-system-pixman"
    "--enable-system-sqlite"
    #"--enable-system-cairo"
    "--enable-startup-notification"
    #"--enable-content-sandbox" # TODO: probably enable after 54
    "--disable-tests"
    "--disable-necko-wifi" # maybe we want to enable this at some point
    "--disable-updater"
    "--enable-jemalloc"
    "--disable-maintenance-service"
    "--disable-gconf"
    "--enable-default-toolkit=cairo-gtk${if gtk3Support then "3" else "2"}"
  ]
  ++ lib.optionals (lib.versionAtLeast version "56" && !stdenv.hostPlatform.isi686) [
    # on i686-linux: --with-libclang-path is not available in this configuration
    "--with-libclang-path=${llvmPackages.libclang}/lib"
    "--with-clang-path=${llvmPackages.clang}/bin/clang"
  ]
  ++ lib.optionals (lib.versionAtLeast version "57") [
    "--enable-webrender=build"
  ]

  # TorBrowser patches these
  ++ lib.optionals (!isTorBrowserLike) [
    "--with-system-nss"
    "--with-system-nspr"
  ]

  # and wants these
  ++ lib.optionals isTorBrowserLike ([
    "--with-tor-browser-version=${version}"
    "--enable-signmar"
    "--enable-verify-mar"

    # We opt out of TorBrowser's nspr because that patch is useless on
    # anything but Windows and produces zero fingerprinting
    # possibilities on other platforms.
    # Lets save some space instead.
    "--with-system-nspr"
  ] ++ flag geolocationSupport "mozril-geoloc"
    ++ flag safeBrowsingSupport "safe-browsing"
  )

  ++ flag alsaSupport "alsa"
  ++ flag pulseaudioSupport "pulseaudio"
  ++ flag ffmpegSupport "ffmpeg"
  ++ flag gssSupport "negotiateauth"
  ++ lib.optional (!ffmpegSupport) "--disable-gstreamer"
  ++ flag webrtcSupport "webrtc"
  ++ flag crashreporterSupport "crashreporter"
  ++ lib.optional drmSupport "--enable-eme=widevine"

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
  postConfigure = lib.optionalString (lib.versionAtLeast version "58") ''
    cd obj-*
  '';

  preBuild = lib.optionalString (enableOfficialBranding && isTorBrowserLike) ''
    buildFlagsArray=("MOZ_APP_DISPLAYNAME=Tor Browser")
  '';

  makeFlags = lib.optionals enableOfficialBranding [
    "MOZILLA_OFFICIAL=1"
    "BUILD_OFFICIAL=1"
  ]
  ++ extraMakeFlags;

  enableParallelBuilding = true;

  preInstall = ''
    # The following is needed for startup cache creation on grsecurity kernels.
    paxmark m dist/bin/xpcshell
  '';

  postInstall = ''
    # For grsecurity kernels
    paxmark m $out/lib/firefox-[0-9]*/{firefox,firefox-bin,plugin-container}

    # Remove SDK cruft. FIXME: move to a separate output?
    rm -rf $out/share/idl $out/include $out/lib/firefox-devel-*

    # Needed to find Mozilla runtime
    gappsWrapperArgs+=(--argv0 "$out/bin/.firefox-wrapped")
  '';

  postFixup = ''
    # Fix notifications. LibXUL uses dlopen for this, unfortunately; see #18712.
    patchelf --set-rpath "${lib.getLib libnotify
      }/lib:$(patchelf --print-rpath "$out"/lib/firefox-*/libxul.so)" \
        "$out"/lib/firefox-*/libxul.so
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    # Some basic testing
    "$out/bin/firefox" --version
  '';

  passthru = {
    browserName = "firefox";
    inherit version updateScript;
    isFirefox3Like = true;
    inherit isTorBrowserLike;
    gtk = gtk2;
    inherit nspr;
    inherit ffmpegSupport;
    inherit gssSupport;
  } // lib.optionalAttrs gtk3Support { inherit gtk3; };

} // overrides)
