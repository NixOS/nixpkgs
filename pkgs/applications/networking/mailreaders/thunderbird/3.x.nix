{ stdenv, fetchurl, pkgconfig, gtk, perl, python, zip, libIDL
, dbus_glib, bzip2, alsaLib, nspr

, # If you want the resulting program to call itself "Thunderbird"
  # instead of "Shredder", enable this option.  However, those
  # binaries may not be distributed without permission from the
  # Mozilla Foundation, see
  # http://www.mozilla.org/foundation/trademarks/.
  enableOfficialBranding ? false
    
}:

let version = "3.0.4"; in

stdenv.mkDerivation {
  name = "thunderbird-${version}";

  src = fetchurl {
    url = "http://releases.mozilla.org/pub/mozilla.org/thunderbird/releases/${version}/source/thunderbird-${version}.source.tar.bz2";
    sha1 = "5a6e89096da61a520e5cecb61f8afeb981f90412";
  };

  buildInputs =
    [ pkgconfig perl python zip bzip2 gtk dbus_glib alsaLib libIDL nspr ];

  configureFlags =
    [ "--enable-application=mail"
      "--enable-optimize"
      "--disable-debug"
      "--enable-strip"
      "--with-system-jpeg"
      "--with-system-zlib"
      "--with-system-bz2"
      "--with-system-nspr"
      "--enable-system-cairo"
      "--disable-crashreporter"
      "--disable-tests"
      "--enable-static" # required by `make install'
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
      # Fix some references to /bin paths in the Xulrunner shell script.
      substituteInPlace $out/lib/thunderbird-*/thunderbird \
          --replace /bin/pwd "$(type -tP pwd)" \
          --replace /bin/ls "$(type -tP ls)"
    '';

  meta = {
    description = "Mozilla Thunderbird, a full-featured email client";
    homepage = http://www.mozilla.com/en-US/thunderbird/;
  };
}
