{ pname, version, updateScript ? null
, src, patches ? [], meta }:

{ lib, stdenv, pkgconfig, pango, perl, python, zip, libIDL
, libjpeg, zlib, dbus, dbus_glib, bzip2, xorg
, freetype, fontconfig, file, nspr, nss, libnotify
, yasm, mesa, sqlite, unzip, makeWrapper
, hunspell, libevent, libstartup_notification, libvpx
, cairo, icu, libpng, jemalloc
, autoconf213, which, gnused, cargo, rustc

, debugBuild ? false

### optionals

, alsaSupport ? true, alsaLib
, pulseaudioSupport ? true, libpulseaudio
, ffmpegSupport ? true, gstreamer, gst-plugins-base
, gtk3Support ? true, gtk2, gtk3, wrapGAppsHook

, webrtcSupport ? true
, geolocationSupport ? true
, googleAPISupport ? geolocationSupport
, crashreporterSupport ? false

, safeBrowsingSupport ? false
, drmSupport ? false

# If you want the resulting program to call itself "Firefox" instead
# of "Nightly" or whatever, enable this option.  However, those
# binaries may not be distributed without permission from the
# Mozilla Foundation, see
# http://www.mozilla.org/foundation/trademarks/.
, enableOfficialBranding ? false
}:

assert stdenv.cc ? libc && stdenv.cc.libc != null;

let
  flag = tf: x: [(if tf then "--enable-${x}" else "--disable-${x}")];
in

stdenv.mkDerivation rec {
  name = "${pname}-unwrapped-${version}";

  inherit src patches meta;

  buildInputs = [
    gtk2 perl zip libIDL libjpeg zlib bzip2
    dbus dbus_glib pango freetype fontconfig xorg.libXi
    xorg.libX11 xorg.libXrender xorg.libXft xorg.libXt file
    nss nspr libnotify xorg.pixman yasm mesa
    xorg.libXScrnSaver xorg.scrnsaverproto
    xorg.libXext xorg.xextproto sqlite unzip makeWrapper
    hunspell libevent libstartup_notification libvpx /* cairo */
    icu libpng jemalloc
  ]
  ++ lib.optional  alsaSupport alsaLib
  ++ lib.optional  pulseaudioSupport libpulseaudio # only headers are needed
  ++ lib.optionals ffmpegSupport [ gstreamer gst-plugins-base ]
  ++ lib.optional  gtk3Support gtk3;

  nativeBuildInputs =
    [ autoconf213 which gnused pkgconfig perl python cargo rustc ]
    ++ lib.optional gtk3Support wrapGAppsHook;

  preConfigure = ''
    # remove distributed configuration files
    rm -f configure
    rm -f js/src/configure
    rm -f .mozconfig*

    # this will run autoconf213
    make -f client.mk configure-files

    configureScript="$(realpath ./configure)"
    cd obj-*
  '' + lib.optionalString googleAPISupport ''
    # Google API key used by Chromium and Firefox.
    # Note: These are for NixOS/nixpkgs use ONLY. For your own distribution,
    # please get your own set of keys.
    echo "AIzaSyDGi15Zwl11UNe6Y-5XW_upsfyw31qwZPI" >ga
  '';

  configureFlags = [
    "--enable-application=browser"
    "--with-system-jpeg"
    "--with-system-zlib"
    "--with-system-bz2"
    "--with-system-nspr"
    "--with-system-nss"
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
    "--enable-content-sandbox" # available since 26.0, but not much info available
    "--disable-tests"
    "--disable-necko-wifi" # maybe we want to enable this at some point
    "--disable-updater"
    "--enable-jemalloc"
    "--disable-maintenance-service"
    "--disable-gconf"
    "--enable-default-toolkit=cairo-gtk${if gtk3Support then "3" else "2"}"
  ]
  ++ flag alsaSupport "alsa"
  ++ flag pulseaudioSupport "pulseaudio"
  ++ flag ffmpegSupport "ffmpeg"
  ++ lib.optional (!ffmpegSupport) "--disable-gstreamer"
  ++ flag webrtcSupport "webrtc"
  ++ flag geolocationSupport "mozril-geoloc"
  ++ lib.optional googleAPISupport "--with-google-api-keyfile=ga"
  ++ flag crashreporterSupport "crashreporter"
  ++ flag safeBrowsingSupport "safe-browsing"
  ++ flag drmSupport "eme"

  ++ (if debugBuild then [ "--enable-debug" "--enable-profiling" ]
                    else [ "--disable-debug" "--enable-release"
                           "--enable-optimize"
                           "--enable-strip" ])
  ++ lib.optional enableOfficialBranding "--enable-official-branding";

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
    gtk = gtk2;
    inherit nspr;
    inherit ffmpegSupport;
  };
}
