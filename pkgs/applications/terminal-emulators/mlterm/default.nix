{ stdenv, lib, fetchFromGitHub, pkg-config, autoconf, makeDesktopItem
, libX11, gdk-pixbuf, cairo, libXft, gtk3, vte
, harfbuzz #substituting glyphs with opentype fonts
, fribidi, m17n_lib #bidi and encoding
, openssl, libssh2 #build-in ssh
, fcitx, ibus, uim #IME
, wrapGAppsHook #color picker in mlconfig
, Cocoa #Darwin
}:

stdenv.mkDerivation rec {
  pname = "mlterm";
  version = "3.9.2";

  src = fetchFromGitHub {
    owner = "arakiken";
    repo = pname;
    rev = version;
    sha256 = "sha256-DvGR3rDegInpnLp3H+rXNXktCGhpjsBBPTRMwodeTro=";
  };

  nativeBuildInputs = [ pkg-config autoconf wrapGAppsHook ];
  buildInputs = [
    libX11
    gdk-pixbuf.dev
    cairo
    libXft
    gtk3
    harfbuzz
    fribidi
  ] ++ lib.optionals (!stdenv.isDarwin) [
    # need linker magic, not adapted for Darwin yet
    openssl
    libssh2

    # Not supported on Darwin
    vte
    m17n_lib

    fcitx
    ibus
    uim
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
  NIX_LDFLAGS = lib.optionalString (!stdenv.isDarwin) "
    -L${stdenv.cc.cc.lib}/lib
    -lX11 -lgdk_pixbuf-2.0 -lcairo -lfontconfig -lfreetype -lXft
    -lvte-2.91 -lgtk-3 -lharfbuzz -lfribidi -lm17n
  " + lib.optionalString (openssl != null) "
    -lcrypto
  " + lib.optionalString (libssh2 != null) "
    -lssh2
  ";

  configureFlags = [
    "--with-imagelib=gdk-pixbuf" #or mlimgloader depending on your bugs of choice
    "--with-type-engines=cairo,xft,xcore"
    "--with-gtk=3.0"
    "--enable-ind" #indic scripts
    "--enable-fribidi" #bidi scripts
    "--with-tools=mlclient,mlconfig,mlcc,mlterm-menu,mlimgloader,registobmp,mlfc"
     #mlterm-menu and mlconfig depend on enabling gnome.at-spi2-core
     #and configuring ~/.mlterm/key correctly.
 ] ++ lib.optionals (!stdenv.isDarwin) [
   "--with-x=yes"
   "--with-gui=xlib,fb"
    "--enable-m17nlib" #character encodings
 ] ++ lib.optionals stdenv.isDarwin [
    "--with-gui=quartz"
 ] ++ lib.optionals (libssh2 == null) [ " --disable-ssh2" ];

  postInstall = ''
    install -D contrib/icon/mlterm-icon.svg "$out/share/icons/hicolor/scalable/apps/mlterm.svg"
    install -D contrib/icon/mlterm-icon-gnome2.png "$out/share/icons/hicolor/48x48/apps/mlterm.png"
    install -D -t $out/share/applications $desktopItem/share/applications/*
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications/
    cp -a cocoa/mlterm.app $out/Applications/
    install $out/bin/mlterm -Dt $out/Applications/mlterm.app/Contents/MacOS/
  '';

  desktopItem = makeDesktopItem {
    name = "mlterm";
    exec = "mlterm %U";
    icon = "mlterm";
    type = "Application";
    comment = "Terminal emulator";
    desktopName = "mlterm";
    genericName = "Terminal emulator";
    categories = [ "Application" "System" "TerminalEmulator" ];
    startupNotify = false;
  };

  meta = with lib; {
    description = "Multi Lingual TERMinal emulator";
    homepage = "http://mlterm.sourceforge.net/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ vrthra ramkromberg atemu ];
    platforms = with platforms; linux ++ darwin;
  };
}
