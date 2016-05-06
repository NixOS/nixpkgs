{ stdenv, fetchurl, pkgconfig, which, m4, gtk, pango, perl, python, zip, libIDL
, libjpeg, libpng, zlib, dbus, dbus_glib, bzip2, xorg
, freetype, fontconfig, file, alsaLib, nspr, nss, libnotify
, yasm, mesa, sqlite, unzip, makeWrapper, pysqlite
, hunspell, libevent, libstartup_notification, libvpx
, cairo, gstreamer, gst_plugins_base, icu
, debugBuild ? false
, # If you want the resulting program to call itself "Thunderbird"
  # instead of "Earlybird", enable this option.  However, those
  # binaries may not be distributed without permission from the
  # Mozilla Foundation, see
  # http://www.mozilla.org/foundation/trademarks/.
  enableOfficialBranding ? false
}:

let version = "45.0"; in
let verName = "${version}"; in

stdenv.mkDerivation rec {
  name = "thunderbird-${verName}";

  src = fetchurl {
    url = "http://archive.mozilla.org/pub/thunderbird/releases/"
      + "${verName}/source/thunderbird-${verName}.source.tar.xz";
    sha256 = "0rynfyxgpvfla17zniaq84slc02kg848qawkjmdbnv74y6bkhs8m";
  };

  buildInputs = # from firefox30Pkgs.xulrunner, without gstreamer and libvpx
    [ pkgconfig which libpng gtk perl zip libIDL libjpeg zlib bzip2
      python dbus dbus_glib pango freetype fontconfig xorg.libXi
      xorg.libX11 xorg.libXrender xorg.libXft xorg.libXt file
      alsaLib nspr nss libnotify xorg.pixman yasm mesa
      xorg.libXScrnSaver xorg.scrnsaverproto pysqlite
      xorg.libXext xorg.xextproto sqlite unzip makeWrapper
      hunspell libevent libstartup_notification cairo icu
    ] ++ [ m4 ];

  configurePhase = let configureFlags = [ "--enable-application=mail" ]
    # from firefox30Pkgs.commonConfigureFlags, but without gstreamer and libvpx
    ++ [
      "--with-system-jpeg"
      "--with-system-zlib"
      "--with-system-bz2"
      "--with-system-nspr"
      "--with-system-nss"
      "--with-system-libevent"
      #"--with-system-libvpx"
      "--with-system-png"
      "--with-system-icu"
      "--enable-system-ffi"
      "--enable-system-hunspell"
      "--enable-system-pixman"
      "--enable-system-sqlite"
      "--enable-system-cairo"
      "--disable-gconf"
      "--disable-gstreamer"
      "--enable-startup-notification"
      # "--enable-content-sandbox"            # available since 26.0, but not much info available
      # "--enable-content-sandbox-reporter"   # keeping disabled for now
      "--disable-crashreporter"
      "--disable-tests"
      "--disable-necko-wifi" # maybe we want to enable this at some point
      "--disable-installer"
      "--disable-updater"
      "--disable-pulseaudio"
    ] ++ (if debugBuild then [ "--enable-debug" "--enable-profiling"]
                        else [ "--disable-debug" "--enable-release"
                               "--disable-debug-symbols"
                               "--enable-optimize" "--enable-strip" ])
    ++ [
      "--disable-javaxpcom"
      #"--enable-stdcxx-compat" # Avoid dependency on libstdc++ 4.7
    ]
    ++ stdenv.lib.optional enableOfficialBranding "--enable-official-branding";
  in ''
    mkdir -p objdir/mozilla
    cd objdir
    echo '${stdenv.lib.concatMapStrings (s : "ac_add_options ${s}\n") configureFlags}' > .mozconfig
    echo 'ac_add_options --prefix="'"$out"'"' >> .mozconfig
    # From version 38, we need to specify the source directory to build
    # Thunderbird. Refer to mozilla/configure and search a line with
    # "checking for application to build" and "# Support comm-central".
    echo 'ac_add_options --with-external-source-dir="'`realpath ..`'"' >> .mozconfig
    echo 'mk_add_options MOZ_MAKE_FLAGS="-j'"$NIX_BUILD_CORES"'"' >> .mozconfig
    echo 'mk_add_options MOZ_OBJDIR="'`pwd`'"' >> .mozconfig

    export MOZCONFIG=`realpath ./.mozconfig`

    patchShebangs ../mozilla/mach
    ../mozilla/mach configure
  '';

  enableParallelBuilding = true;

  buildPhase =  "../mozilla/mach build";

  installPhase =
    ''
      ../mozilla/mach install

      rm -rf $out/include $out/lib/thunderbird-devel-* $out/share/idl

      # Create a desktop item.
      mkdir -p $out/share/applications
      cat > $out/share/applications/thunderbird.desktop <<EOF
      [Desktop Entry]
      Type=Application
      Exec=$out/bin/thunderbird
      Icon=$out/lib/thunderbird-${version}/chrome/icons/default/default256.png
      Name=Thunderbird
      GenericName=Mail Reader
      Categories=Application;Network;
      EOF
    '';

  meta = with stdenv.lib; {
    description = "A full-featured e-mail client";
    homepage = http://www.mozilla.org/thunderbird/;
    license =
      # Official branding implies thunderbird name and logo cannot be reuse,
      # see http://www.mozilla.org/foundation/licensing.html
      if enableOfficialBranding then licenses.proprietary else licenses.mpl11;
    maintainers = [ maintainers.pierron maintainers.eelco ];
    platforms = platforms.linux;
  };
}
