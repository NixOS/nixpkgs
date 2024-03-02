{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, libX11
, libXmu
, libXpm
, gtk2
, libpng
, libjpeg
, libtiff
, librsvg
, gdk-pixbuf
, gdk-pixbuf-xlib
, pypy2
}:

stdenv.mkDerivation rec {
  pname = "fbpanel";
  version = "7.0";
  src = fetchFromGitHub {
    owner = "aanatoly";
    repo = "fbpanel";
    rev = "478754b687e2b48b111507ea22e8e2a001be5199";
    hash = "sha256-+KcVcrh1aV6kjLGyiDnRHXSzJfelXWrhJS0DitG4yPA=";
  };
  nativeBuildInputs = [ pkg-config pypy2 ];
  buildInputs = [
    libX11
    libXmu
    libXpm
    gtk2
    libpng
    libjpeg
    libtiff
    librsvg
    gdk-pixbuf
    gdk-pixbuf-xlib.dev
  ];

  preConfigure = ''
    sed -re '1i#!${pypy2}/bin/pypy' -i configure .config/*.py
    sed -re 's/\<out\>/outputredirect/g' -i .config/rules.mk
    sed -i 's/struct\ \_plugin_instance \*stam\;//' panel/plugin.h
  '';

  makeFlags = ["V=1"];
  NIX_CFLAGS_COMPILE = ["-Wno-error" "-I${gdk-pixbuf-xlib.dev}/include/gdk-pixbuf-2.0"];

  meta = with lib; {
    description = "A stand-alone panel";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.mit;
    mainProgram = "fbpanel";
  };

}
