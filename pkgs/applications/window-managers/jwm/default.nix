{ stdenv, fetchurl, libX11, libXext, libXinerama, libXpm, libXft, freetype,
  fontconfig }:

stdenv.mkDerivation rec {
  name = "jwm-2.2.2";
  
  src = fetchurl {
     url = "http://www.joewing.net/projects/jwm/releases/${name}.tar.xz";
     sha256 = "0nhyy78c6imk85d47bakk460x0cfhkyghqq82zghmb00dhwiryln";
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
