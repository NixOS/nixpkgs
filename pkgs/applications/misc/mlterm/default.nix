{ stdenv, fetchurl, pkgconfig, autoconf, makeDesktopItem
, libX11, gdk_pixbuf, cairo, libXft, gtk3, vte
, harfbuzz #substituting glyphs with opentype fonts
, fribidi, m17n_lib #bidi and encoding
, openssl, libssh2 #build-in ssh
}:

stdenv.mkDerivation rec {
  name = "mlterm-${version}";
  version = "3.7.2";

  src = fetchurl {
    url = "mirror://sourceforge/project/mlterm/01release/${name}/${name}.tar.gz";
    sha256 = "1b24w8hfck1ylfkdz9z55vlmsb36q9iyfr0i9q9y98dfk0f0rrw8";
  };

  nativeBuildInputs = [ pkgconfig autoconf ];
  buildInputs = [
    libX11 gdk_pixbuf.dev cairo libXft gtk3 vte
    harfbuzz fribidi m17n_lib openssl libssh2
  ];

  patches = [ ./x_shortcut.c.patch ]; #fixes numlock in 3.7.2. should be safe to remove by 3.7.3 since it's already in the trunk: https://bitbucket.org/arakiken/mlterm/commits/4820d42c7abfe1760a5ea35492c83be469c642b3

  #bad configure.ac and Makefile.in everywhere
  preConfigure = ''
    sed -ie 's;-L/usr/local/lib -R/usr/local/lib;;g' \
      xwindow/libtype/Makefile.in \
      main/Makefile.in \
      tool/mlfc/Makefile.in \
      tool/mlimgloader/Makefile.in \
      tool/mlconfig/Makefile.in \
      xwindow/libotl/Makefile.in
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
 ] ++ stdenv.lib.optional (libssh2 == null) [
    "--disable-ssh2"
 ];

  postInstall = ''
    mkdir -p "$out/share/icons/hicolor/scalable/apps"
    cp contrib/icon/mlterm-icon.svg "$out/share/icons/hicolor/scalable/apps/mlterm.svg"

    mkdir -p "$out/share/icons/hicolor/48x48/apps"
    cp contrib/icon/mlterm-icon-gnome2.png "$out/share/icons/hicolor/48x48/apps/mlterm.png"

    mkdir -p "$out/share/applications"
    cp $desktopItem/share/applications/* $out/share/applications
  '';

  desktopItem = makeDesktopItem rec {
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
    homepage = http://mlterm.sourceforge.net/;
    license = licenses.bsd2;
    maintainers = with maintainers; [ vrthra ramkromberg ];
    platforms = with platforms; linux;
  };
}
