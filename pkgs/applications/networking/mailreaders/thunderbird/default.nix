{ stdenv, fetchurl, pkgconfig, gtk, perl, python, zip, unzip
, libIDL, dbus_glib, bzip2, alsaLib, nspr, yasm, mesa, nss
, libnotify, cairo, pixman, fontconfig
, libjpeg
, pythonPackages

, # If you want the resulting program to call itself "Thunderbird"
  # instead of "Shredder", enable this option.  However, those
  # binaries may not be distributed without permission from the
  # Mozilla Foundation, see
  # http://www.mozilla.org/foundation/trademarks/.
  enableOfficialBranding ? false
}:

let version = "17.0.8"; in

stdenv.mkDerivation {
  name = "thunderbird-${version}";

  src = fetchurl {
    url = "ftp://ftp.mozilla.org/pub/thunderbird/releases/${version}/source/thunderbird-${version}.source.tar.bz2";
    sha1 = "4bcbb33f0b3ea050e805723680b5669d80438812";
  };

  enableParallelBuilding = true;

  buildInputs =
    [ pkgconfig perl python zip unzip bzip2 gtk dbus_glib alsaLib libIDL nspr
      libnotify cairo pixman fontconfig yasm mesa nss
      libjpeg pythonPackages.sqlite3
    ];

  configureFlags =
    [ "--enable-application=mail"
      "--enable-optimize"
      "--with-pthreads"
      "--disable-debug"
      "--enable-strip"
      "--with-pthreads"
      "--with-system-jpeg"
      #"--with-system-png"
      "--with-system-zlib"
      "--with-system-bz2"
      "--with-system-nspr"
      "--with-system-nss"
      # Broken: https://bugzilla.mozilla.org/show_bug.cgi?id=722975
      #"--enable-system-cairo"
      "--disable-crashreporter"
      "--disable-necko-wifi"
      "--disable-webm"
      "--disable-tests"
      "--enable-calendar"
      "--disable-ogg"
    ]
    ++ stdenv.lib.optional enableOfficialBranding "--enable-official-branding";

  # The Thunderbird Makefiles refer to the variables LIBXUL_DIST,
  # prefix, and PREFIX in some places where they are not set.  In
  # particular, there are some linker flags like
  # `-rpath-link=$(LIBXUL_DIST)/bin'.  Since this expands to
  # `-rpath-link=/bin', the build fails due to the purity checks in
  # the ld wrapper.  So disable the purity check for now.
  preBuild = "NIX_ENFORCE_PURITY=0";

  # This doesn't work:
  #makeFlags = "LIBXUL_DIST=$(out) prefix=$(out) PREFIX=$(out)";

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
    description = "Mozilla Thunderbird, a full-featured email client";
    homepage = http://www.mozilla.org/thunderbird/;
    license =
      # Official branding implies thunderbird name and logo cannot be reuse,
      # see http://www.mozilla.org/foundation/licensing.html
      if enableOfficialBranding then licenses.proprietary else licenses.mpl11;
    maintainers = [ maintainers.pierron maintainers.eelco ];
    platforms = platforms.linux;
  };
}
