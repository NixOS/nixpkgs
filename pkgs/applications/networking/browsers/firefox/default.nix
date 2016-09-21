{ lib, stdenv, fetchurl, pkgconfig, gtk, gtk3, pango, perl, python, zip, libIDL
, libjpeg, zlib, dbus, dbus_glib, bzip2, xorg
, freetype, fontconfig, file, alsaLib, nspr, nss, libnotify
, yasm, mesa, sqlite, unzip, makeWrapper, pysqlite
, hunspell, libevent, libstartup_notification, libvpx
, cairo, gstreamer, gst_plugins_base, icu, libpng, jemalloc, libpulseaudio
, autoconf213, which
, enableGTK3 ? false
, debugBuild ? false
, # If you want the resulting program to call itself "Firefox" instead
  # of "Shiretoko" or whatever, enable this option.  However, those
  # binaries may not be distributed without permission from the
  # Mozilla Foundation, see
  # http://www.mozilla.org/foundation/trademarks/.
  enableOfficialBranding ? false
}:

assert stdenv.cc ? libc && stdenv.cc.libc != null;

let

common = { pname, version, sha512 }: stdenv.mkDerivation rec {
  name = "${pname}-unwrapped-${version}";

  src = fetchurl {
    url =
      let ext = if lib.versionAtLeast version "41.0" then "xz" else "bz2";
      in "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.${ext}";
    inherit sha512;
  };

  buildInputs =
    [ pkgconfig gtk perl zip libIDL libjpeg zlib bzip2
      python dbus dbus_glib pango freetype fontconfig xorg.libXi
      xorg.libX11 xorg.libXrender xorg.libXft xorg.libXt file
      alsaLib nspr nss libnotify xorg.pixman yasm mesa
      xorg.libXScrnSaver xorg.scrnsaverproto pysqlite
      xorg.libXext xorg.xextproto sqlite unzip makeWrapper
      hunspell libevent libstartup_notification libvpx /* cairo */
      icu libpng jemalloc
      libpulseaudio # only headers are needed
    ]
    ++ lib.optional enableGTK3 gtk3
    ++ lib.optionals (!passthru.ffmpegSupport) [ gstreamer gst_plugins_base ];

  nativeBuildInputs = [autoconf213 which];

  configureFlags =
    [ "--enable-application=browser"
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
      "--enable-content-sandbox"            # available since 26.0, but not much info available
      "--disable-crashreporter"
      "--disable-tests"
      "--disable-necko-wifi" # maybe we want to enable this at some point
      "--disable-updater"
      "--enable-jemalloc"
      "--disable-gconf"
      "--enable-default-toolkit=cairo-gtk2"
    ]
    ++ lib.optional enableGTK3 "--enable-default-toolkit=cairo-gtk3"
    ++ (if debugBuild then [ "--enable-debug" "--enable-profiling" ]
                      else [ "--disable-debug" "--enable-release"
                             "--enable-optimize"
                             "--enable-strip" ])
    ++ lib.optional enableOfficialBranding "--enable-official-branding";

  enableParallelBuilding = true;

  preConfigure =
    ''
      configureScript="$(realpath ./configure)"
      mkdir ../objdir
      cd ../objdir
    '';

  preInstall =
    ''
      # The following is needed for startup cache creation on grsecurity kernels.
      paxmark m ../objdir/dist/bin/xpcshell
    '';

  postInstall =
    ''
      # For grsecurity kernels
      paxmark m $out/lib/firefox-[0-9]*/{firefox,firefox-bin,plugin-container}

      # Remove SDK cruft. FIXME: move to a separate output?
      rm -rf $out/share/idl $out/include $out/lib/firefox-devel-*
    '' + lib.optionalString enableGTK3
      # argv[0] must point to firefox itself
    ''
      wrapProgram "$out/bin/firefox" \
        --argv0 "$out/bin/.firefox-wrapped" \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:" \
        --suffix XDG_DATA_DIRS : "$XDG_ICON_DIRS"
    '' +
      # some basic testing
    ''
      "$out/bin/firefox" --version
    '';

  postFixup =
    # Fix notifications. LibXUL uses dlopen for this, unfortunately; see #18712.
    ''
      patchelf --set-rpath "${lib.getLib libnotify
        }/lib:$(patchelf --print-rpath "$out"/lib/firefox-*/libxul.so)" \
          "$out"/lib/firefox-*/libxul.so
    '';

  meta = {
    description = "A web browser" + lib.optionalString (pname == "firefox-esr") " (Extended Support Release)";
    homepage = http://www.mozilla.com/en-US/firefox/;
    maintainers = with lib.maintainers; [ eelco ];
    platforms = lib.platforms.linux;
  };

  passthru = {
    inherit gtk nspr version;
    isFirefox3Like = true;
    browserName = "firefox";
    ffmpegSupport = lib.versionAtLeast version "46.0";
  };
};

in {

  firefox-unwrapped = common {
    pname = "firefox";
    version = "49.0";
    sha512 = "9431f86dec5587131699ae57ae428be168e4d6c7d1d48df643c10540e8e18bc5eadfcd08bb204950be611c87d35d8a40aa8ece454b7dfa3992239639c2d688a9";
  };

  firefox-esr-unwrapped = common {
    pname = "firefox-esr";
    version = "45.4.0esr";
    sha512 = "2955e02f829a10186a8b22320fb97d4b0fc2b45721fcffa6295653fd760d516ae72b5656547685ba1e0699b381e28044996d9ee12a8738842b4e6b8acd296715";
  };

}
