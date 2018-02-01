{ pname, version, updateScript ? null
, src, patches ? [], extraConfigureFlags ? [], extraMakeFlags ? [], overrides ? {}, meta
, isTorBrowserLike ? false }:

{ lib, stdenv, pkgconfig, pango, perl, python, zip, libIDL
, libjpeg, zlib, dbus, dbus_glib, bzip2, xorg
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

# If you want the resulting program to call itself
# "Firefox"/"Torbrowser" instead of "Nightly" or whatever, enable this
# option. However, in Firefox's case, those binaries may not be
# distributed without permission from the Mozilla Foundation, see
# http://www.mozilla.org/foundation/trademarks/.
, enableOfficialBranding ? isTorBrowserLike
}:

assert stdenv.cc ? libc && stdenv.cc.libc != null;

let
  flag = tf: x: [(if tf then "--enable-${x}" else "--disable-${x}")];
  gcc = if stdenv.cc.isGNU then stdenv.cc.cc else stdenv.cc.cc.gcc;
in

stdenv.mkDerivation (rec {
  name = "${pname}-unwrapped-${version}";

  inherit src patches meta;

  buildInputs = [
    gtk2 perl zip libIDL libjpeg zlib bzip2
    dbus dbus_glib pango freetype fontconfig xorg.libXi
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
  ++ lib.optional  gtk3Support gtk3;

  NIX_CFLAGS_COMPILE = "-I${nspr.dev}/include/nspr -I${nss.dev}/include/nss";

  nativeBuildInputs =
    [ autoconf213 which gnused pkgconfig perl python cargo rustc ]
    ++ lib.optional gtk3Support wrapGAppsHook;

  preConfigure = ''
    # remove distributed configuration files
    rm -f configure
    rm -f js/src/configure
    rm -f .mozconfig*

 '' + lib.optionalString (stdenv.lib.versionAtLeast version "58.0.0") ''
    cat >.mozconfig <<END_MOZCONFIG
    ${lib.concatStringsSep "\n" (map (flag: "ac_add_options ${flag}") configureFlags)}
    ${lib.optionalString googleAPISupport "ac_add_options --with-google-api-keyfile=$TMPDIR/ga"}
    END_MOZCONFIG
  '' + lib.optionalString googleAPISupport ''
    # Google API key used by Chromium and Firefox.
    # Note: These are for NixOS/nixpkgs use ONLY. For your own distribution,
    # please get your own set of keys.
    echo "AIzaSyDGi15Zwl11UNe6Y-5XW_upsfyw31qwZPI" > $TMPDIR/ga
    configureFlagsArray+=("--with-google-api-keyfile=$TMPDIR/ga")
  '' + ''
    # this will run autoconf213
    ${if (stdenv.lib.versionAtLeast version "58.0.0") then "./mach configure" else "make -f client.mk configure-files"}

    configureScript="$(realpath ./configure)"

    cxxLib=$( echo -n ${gcc}/include/c++/* )
    archLib=$cxxLib/$( ${gcc}/bin/gcc -dumpmachine )

    test -f layout/style/ServoBindings.toml && sed -i -e '/"-DMOZ_STYLO"/ a , "-cxx-isystem", "'$cxxLib'", "-isystem", "'$archLib'"' layout/style/ServoBindings.toml

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
  ++ lib.optionals (stdenv.lib.versionAtLeast version "56") [
    "--with-libclang-path=${llvmPackages.clang-unwrapped}/lib"
    "--with-clang-path=${llvmPackages.clang}/bin/clang"
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
  } // lib.optionalAttrs gtk3Support { inherit gtk3; };

} // overrides)
