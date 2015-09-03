{ lib, stdenv, fetchurl, pkgconfig, gtk, gtk3, pango, perl, python, zip, libIDL
, libjpeg, zlib, dbus, dbus_glib, bzip2, xlibs
, freetype, fontconfig, file, alsaLib, nspr, nss, libnotify
, yasm, mesa, sqlite, unzip, makeWrapper, pysqlite
, hunspell, libevent, libstartup_notification, libvpx
, cairo, gstreamer, gst_plugins_base, icu, libpng, jemalloc, libpulseaudio
, enableGTK3 ? false, fetchpatch
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

common = { pname, version, sha1 }: stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://ftp.mozilla.org/pub/mozilla.org/firefox/releases/${version}/source/firefox-${version}.source.tar.bz2";
    inherit sha1;
  };

  patches = if !enableGTK3 then null else [(fetchpatch {
    name = "crash_OTMC+GTK3.patch";
    # backported from 40.1
    # https://bugzilla.mozilla.org/show_bug.cgi?id=1127752
    # https://bugzilla.redhat.com/show_bug.cgi?id=1256875
    url = "http://pkgs.fedoraproject.org/cgit/firefox.git/plain/"
      + "mozilla-1127752.patch?id=571fefe2c8f741b92c865e9122af56f6258b3fc1";
    sha256 = "04yq4lcq8ln2fmknz4c0zah77wxqp2mcgr8pjx860dmcmzvyi3p5";
  })];
  patchFlags = "-p2";

  buildInputs =
    [ pkgconfig gtk perl zip libIDL libjpeg zlib bzip2
      python dbus dbus_glib pango freetype fontconfig xlibs.libXi
      xlibs.libX11 xlibs.libXrender xlibs.libXft xlibs.libXt file
      alsaLib nspr nss libnotify xlibs.pixman yasm mesa
      xlibs.libXScrnSaver xlibs.scrnsaverproto pysqlite
      xlibs.libXext xlibs.xextproto sqlite unzip makeWrapper
      hunspell libevent libstartup_notification libvpx /* cairo */
      gstreamer gst_plugins_base icu libpng jemalloc
      libpulseaudio # only headers are needed
    ]
    ++ lib.optional enableGTK3 gtk3;

  configureFlags =
    [ "--enable-application=browser"
      "--disable-javaxpcom"
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
      "--enable-gstreamer"
      "--enable-startup-notification"
      "--enable-content-sandbox"            # available since 26.0, but not much info available
      "--disable-content-sandbox-reporter"  # keeping disabled for now
      "--disable-crashreporter"
      "--disable-tests"
      "--disable-necko-wifi" # maybe we want to enable this at some point
      "--disable-installer"
      "--disable-updater"
      "--enable-jemalloc"
    ]
    ++ lib.optional enableGTK3 "--enable-default-toolkit=cairo-gtk3"
    ++ (if debugBuild then [ "--enable-debug" "--enable-profiling" ]
                      else [ "--disable-debug" "--enable-release"
                             "--enable-optimize${lib.optionalString (stdenv.system == "i686-linux") "=-O1"}"
                             "--enable-strip" ])
    ++ lib.optional enableOfficialBranding "--enable-official-branding";

  enableParallelBuilding = true;

  preConfigure =
    ''
      mkdir ../objdir
      cd ../objdir
      configureScript=../mozilla-*/configure
    '';

  preInstall =
    ''
      # The following is needed for startup cache creation on grsecurity kernels.
      paxmark m ../objdir/dist/bin/xpcshell
    '';

  postInstall =
    ''
      # For grsecurity kernels
      paxmark m $out/lib/${name}/{firefox,firefox-bin,plugin-container}

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
  };
};

in {

  firefox = common {
    pname = "firefox";
    version = "40.0.3";
    sha1 = "6ddda46bd6540ab3ae932fbb5ffec8e9a85cab13";
  };

  firefox-esr = common {
    pname = "firefox-esr";
    version = "38.2.1esr";
    sha1 = "c596174e7273be5079bf55aecde33ec191d99538";
  };

}
