{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  glib,
  ncurses,
  gpm,
}:
stdenv.mkDerivation rec {
  pname = "libviper";
  version = "1.4.6";

  src = fetchurl {
    url = "mirror://sourceforge/libviper/libviper-${version}.tar.gz";
    sha256 = "1jvm7wdgw6ixyhl0pcfr9lnr9g6sg6whyrs9ihjiz0agvqrgvxwc";
  };

  postPatch = ''
    sed -i -e s@/usr/local@$out@ -e /ldconfig/d -e '/cd vdk/d' Makefile

    # Fix pending upstream inclusion for ncurses-6.3 support:
    #   https://github.com/TragicWarrior/libviper/pull/16
    # Not applied as it due to unrelated code changes in context.
    substituteInPlace viper_msgbox.c --replace \
      'mvwprintw(window,height-3,tmp,prompt);' \
      'mvwprintw(window,height-3,tmp,"%s",prompt);'
    substituteInPlace w_decorate.c --replace \
      'mvwprintw(window,0,x,title);' \
      'mvwprintw(window,0,x,"%s",title);'
  '';

  preInstall = ''
    mkdir -p $out/include
    mkdir -p $out/lib
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    glib
    ncurses
    gpm
  ];

  meta = with lib; {
    homepage = "http://libviper.sourceforge.net/";
    description = "Simple window creation and management facilities for the console";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
