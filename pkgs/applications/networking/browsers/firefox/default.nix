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
    version = "48.0.2";
    sha512 = "d5addb0cd01e2aeb0fd9387800e82e385f3986716887840322d261d772a442f6fdb1d910cd53f2373f0fb82ed0b2a45356ac83f3ef230e14a2b9db8999ad8a4e";
  };

  firefox-esr-unwrapped = common {
    pname = "firefox-esr";
    version = "45.3.0esr";
    sha512 = "ee618aec579625122c3e511a7ac83ac4db9718f5695b6fe6250717602178bae9bb7e5ebe8764f4d33ecf44d3db13abfed0d24c1ec71e64a1087fb6d5a579b0c0";
  };

}
