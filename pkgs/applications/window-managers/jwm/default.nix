{ stdenv, fetchurl, libX11, libXext, libXinerama, libXpm, libXft, freetype,
  fontconfig }:

stdenv.mkDerivation {
  name = "jwm-2.0.1";
  
  src = fetchurl {
     url = http://www.joewing.net/programs/jwm/releases/jwm-2.0.1.tar.bz2;
     sha256 = "1ix5y00cmg3cyazl0adzgv49140zxaf2dpngyg1dyy4ma6ysdmnw";
  };

  buildInputs = [ libX11 libXext libXinerama libXpm libXft freetype 
    fontconfig ];

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${freetype}/include/freetype2 "
    export NIX_LDFLAGS="$NIX_LDFLAGS -lXft -lfreetype -lfontconfig "
  '';

  postInstall =
    ''
      sed -i -e s/rxvt/xterm/g $out/etc/system.jwmrc
      sed -i -e "s/.*Swallow.*\|.*xload.*//" $out/etc/system.jwmrc
    '';

  meta = {
    description = "A window manager for X11 that requires only Xlib";
  };
}
