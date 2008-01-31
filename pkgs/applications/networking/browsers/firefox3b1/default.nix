args: with args;

stdenv.mkDerivation {
  name = "firefox-3b1";

  src = 
	fetchurl {
		url = ftp://ftp.mozilla.org/pub/firefox/releases/3.0b1/source/firefox-3.0b1-source.tar.bz2;
		sha256 = "02mh87aidr33gp33fasq9xx23jqf7lm7yfsb2a36ijnd3bpnssn9";
	};

  buildInputs = [
    pkgconfig gtk perl zip libIDL libXi libjpeg libpng zlib cairo
    python curl coreutils
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
    /*"--enable-system-cairo"*/
  ]
;

  postConfigure = "
	cp -r . /tmp/ff3b1-build
  ";

  postInstall = "
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
    homepage = http://www.mozilla.com/en-US/firefox/;
  };

  passthru = {inherit gtk;};
}

