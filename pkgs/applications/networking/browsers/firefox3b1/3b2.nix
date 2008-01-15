args: with args;

stdenv.mkDerivation {
  name = "firefox-3b2";

  src = 
	fetchurl {
		url = ftp://ftp.mozilla.org/pub/firefox/releases/3.0b2/source/firefox-3.0b2-source.tar.bz2;
		sha256 = "0mszad8j35wvzi67dp3j9sznqkgb9b3in22c5790g9b9pv6xk8jp";
	};

  buildInputs = [
    pkgconfig gtk perl zip libIDL libXi libjpeg libpng zlib cairo
    python curl coreutils dbus dbus_glib pango freetype fontconfig 
    libX11 libXrender libXft libXt
  ];

  configureFlags = [
    "--enable-application=browser"
    "--enable-optimize"
    "--disable-debug"
    "--enable-xft"
    "--disable-freetype2"
    "--enable-svg"
    "--enable-canvas"
    "--enable-strip"
    "--enable-default-toolkit=cairo-gtk2"
    "--with-system-jpeg"
    "--with-system-zlib"
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*     "--enable-system-cairo"
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
  ]
;

  postInstall = "
    export dontPatchELF=1;
    sed -e 's@moz_libdir=.*@&\\nexport PATH=\$PATH:${coreutils}/bin@' -i \$out/bin/firefox 
    sed -e 's@`/bin/pwd@`${coreutils}/bin/pwd@' -i \$out/bin/firefox 
    sed -e 's@`/bin/ls@`${coreutils}/bin/ls@' -i \$out/bin/firefox 

    strip -S \$out/lib/*/* || true

    libDir=\$(cd \$out/lib && ls -d firefox-[0-9]*)
    test -n \"\$libDir\"

    echo \"running firefox -register...\"
    (cd \$out/lib/\$libDir && LD_LIBRARY_PATH=. ./firefox-bin -register) || false
  ";

  meta = {
    description = "Mozilla Firefox - the browser, reloaded";
  };

  passthru = {inherit gtk;};
}

