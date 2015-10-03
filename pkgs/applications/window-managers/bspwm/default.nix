{ stdenv, fetchurl, libxcb, libXinerama, sxhkd, xcbutil, xcbutilkeysyms, xcbutilwm }:

stdenv.mkDerivation rec {
  name = "bspwm-0.9";
  

  src = fetchurl {
    url = "https://github.com/baskerville/bspwm/archive/0.9.tar.gz";
    sha256 = "1efb2db7b8a251bcc006d66a050cf66e9d311761c94890bebf91a32905042fde";
  };

  buildInputs = [ libxcb libXinerama xcbutil xcbutilkeysyms xcbutilwm ];

  buildPhase = ''
    make PREFIX=$out
  '';
 
  installPhase = ''
    make PREFIX=$out install
  '';

  meta = {
    description = "A tiling window manager based on binary space partitioning";
    homepage = http://github.com/baskerville/bspwm;
    maintainers = [ stdenv.lib.maintainers.meisternu stdenv.lib.maintainers.epitrochoid ];
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.linux;
  };
}
