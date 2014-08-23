{ stdenv, fetchurl, pkgconfig, m4, gtk, pango, perl, python, zip, libIDL
, libjpeg, libpng, zlib, dbus, dbus_glib, bzip2, xlibs
, freetype, fontconfig, file, alsaLib, nspr, nss, libnotify
, yasm, mesa, sqlite, unzip, makeWrapper, pysqlite
, hunspell, libevent, libstartup_notification, libvpx
, cairo, gstreamer, gst_plugins_base, icu
, debugBuild ? false
, # If you want the resulting program to call itself "Thunderbird"
  # instead of "Shredder", enable this option.  However, those
  # binaries may not be distributed without permission from the
  # Mozilla Foundation, see
  # http://www.mozilla.org/foundation/trademarks/.
  enableOfficialBranding ? false
}:

let version = "31.0"; in
let verName = "${version}"; in

stdenv.mkDerivation rec {
  name = "thunderbird-${verName}";

  src = fetchurl {
    url = "ftp://ftp.mozilla.org/pub/thunderbird/releases/${verName}/source/thunderbird-${verName}.source.tar.bz2";
    sha1 = "0fe6666fddd4db82ec2e389f30c5ea11d4f72be5";
  };

  buildInputs = # from firefox30Pkgs.xulrunner, but without gstreamer and libvpx
    [ pkgconfig libpng gtk perl zip libIDL libjpeg zlib bzip2
      python dbus dbus_glib pango freetype fontconfig xlibs.libXi
      xlibs.libX11 xlibs.libXrender xlibs.libXft xlibs.libXt file
      alsaLib nspr nss libnotify xlibs.pixman yasm mesa
      xlibs.libXScrnSaver xlibs.scrnsaverproto pysqlite
      xlibs.libXext xlibs.xextproto sqlite unzip makeWrapper
      hunspell libevent libstartup_notification cairo icu
    ] ++ [ m4 ];

  configureFlags = [ "--enable-application=mail" ]
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
                               "--enable-optimize" "--enable-strip" ])
    ++ [
      "--disable-javaxpcom"
      "--enable-stdcxx-compat" # Avoid dependency on libstdc++ 4.7
    ]
    ++ stdenv.lib.optional enableOfficialBranding "--enable-official-branding";

  configurePhase = ''
    patchShebangs .

    echo '${stdenv.lib.concatMapStrings (s : "ac_add_options ${s}\n") configureFlags}' > .mozconfig
    echo "ac_add_options --prefix='$out'" >> .mozconfig
    echo "mk_add_options MOZ_MAKE_FLAGS='-j$NIX_BUILD_CORES'" >> .mozconfig

    make ${makeFlags} configure
  '';

  makeFlags = "-f client.mk";
  buildFlags = "build";

  postInstall =
    ''
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
