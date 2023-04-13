{ stdenv, lib, fetchFromGitHub, pkg-config, autoconf, makeDesktopItem, nixosTests
, libX11, gdk-pixbuf, cairo, libXft, gtk3, vte
, harfbuzz #substituting glyphs with opentype fonts
, fribidi, m17n_lib #bidi and encoding
, libssh2 #build-in ssh
, fcitx5, fcitx5-gtk, ibus, uim #IME
, wrapGAppsHook #color picker in mlconfig
, Cocoa #Darwin
}:

stdenv.mkDerivation rec {
  pname = "mlterm";
  version = "3.9.3";

  src = fetchFromGitHub {
    owner = "arakiken";
    repo = pname;
    rev = version;
    sha256 = "sha256-gfs5cdwUUwSBWwJJSaxrQGWJvLkI27RMlk5QvDALEDg=";
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
    vte

    libssh2
  ] ++ lib.optionals (!stdenv.isDarwin) [
    # Not supported on Darwin
    m17n_lib

    fcitx5
    fcitx5-gtk
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
  ];

  enableParallelBuilding = true;

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

  passthru.tests.test = nixosTests.terminal-emulators.mlterm;

  meta = with lib; {
    description = "Multi Lingual TERMinal emulator";
    homepage = "https://mlterm.sourceforge.net/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ramkromberg atemu ];
    platforms = platforms.all;
  };
}
