{ stdenv, fetchurl, pkgconfig, autoconf, makeDesktopItem
, libX11, gdk-pixbuf, cairo, libXft, gtk3, vte
, harfbuzz #substituting glyphs with opentype fonts
, fribidi, m17n_lib #bidi and encoding
, openssl, libssh2 #build-in ssh
}:

stdenv.mkDerivation rec {
  pname = "mlterm";
  version = "3.8.9";

  src = fetchurl {
    url = "mirror://sourceforge/project/mlterm/01release/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "1iy7wq953gcnygr1d04h5ddvhpmy8l575n5is2w0rj3ck31ihpqd";
  };

  nativeBuildInputs = [ pkgconfig autoconf ];
  buildInputs = [
    libX11 gdk-pixbuf.dev cairo libXft gtk3 vte
    harfbuzz fribidi m17n_lib openssl libssh2
  ];

  #bad configure.ac and Makefile.in everywhere
  preConfigure = ''
    sed -ie 's;-L/usr/local/lib -R/usr/local/lib;;g' \
      main/Makefile.in \
      tool/mlfc/Makefile.in \
      tool/mlimgloader/Makefile.in \
      tool/mlconfig/Makefile.in \
      uitoolkit/libtype/Makefile.in \
      uitoolkit/libotl/Makefile.in
    sed -ie 's;cd ..srcdir. && rm -f ...lang..gmo.*;;g' \
      tool/mlconfig/po/Makefile.in.in
    #utmp and mlterm-fb
    substituteInPlace configure.in \
      --replace "-m 2755 -g utmp" " " \
      --replace "-m 4755 -o root" " "
    substituteInPlace configure \
      --replace "-m 2755 -g utmp" " " \
      --replace "-m 4755 -o root" " "
  '';
  NIX_LDFLAGS = "
    -L${stdenv.cc.cc.lib}/lib
    -lX11 -lgdk_pixbuf-2.0 -lcairo -lfontconfig -lfreetype -lXft
    -lvte-2.91 -lgtk-3 -lharfbuzz -lfribidi -lm17n
  " + stdenv.lib.optionalString (openssl != null) "
    -lcrypto
  " + stdenv.lib.optionalString (libssh2 != null) "
    -lssh2
  ";

  configureFlags = [
    "--with-x=yes"
    "--with-gui=xlib,fb"
    "--with-imagelib=gdk-pixbuf" #or mlimgloader depending on your bugs of choice
    "--with-type-engines=cairo,xft,xcore"
    "--with-gtk=3.0"
    "--enable-ind" #indic scripts
    "--enable-fribidi" #bidi scripts
    "--enable-m17nlib" #character encodings
    "--with-tools=mlclient,mlconfig,mlcc,mlterm-menu,mlimgloader,registobmp,mlfc"
     #mlterm-menu and mlconfig depend on enabling gnome3.at-spi2-core
     #and configuring ~/.mlterm/key correctly.
 ] ++ stdenv.lib.optional (libssh2 == null) "--disable-ssh2";

  postInstall = ''
    install -D contrib/icon/mlterm-icon.svg "$out/share/icons/hicolor/scalable/apps/mlterm.svg"
    install -D contrib/icon/mlterm-icon-gnome2.png "$out/share/icons/hicolor/48x48/apps/mlterm.png"
    install -D -t $out/share/applications $desktopItem/share/applications/*
  '';

  desktopItem = makeDesktopItem {
    name = "mlterm";
    exec = "mlterm %U";
    icon = "mlterm";
    type = "Application";
    comment = "Terminal emulator";
    desktopName = "mlterm";
    genericName = "Terminal emulator";
    categories = stdenv.lib.concatStringsSep ";" [
      "Application" "System" "TerminalEmulator"
    ];
    startupNotify = "false";
  };

  meta = with stdenv.lib; {
    description = "Multi Lingual TERMinal emulator on X11";
    homepage = http://mlterm.sourceforge.net/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ vrthra ramkromberg ];
    platforms = with platforms; linux;
  };
}
