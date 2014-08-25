{ stdenv, fetchurl, libxcb, libXinerama, sxhkd, xcbutil, xcbutilkeysyms, xcbutilwm }:

stdenv.mkDerivation rec {
  name = "bspwm-0.8.9";
  

  src = fetchurl {
    url = "https://github.com/baskerville/bspwm/archive/0.8.9.tar.gz";
    sha256 = "750c76132914661d8d5edf7809e9b601977215d31e747dd780c60fd562913d55";
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
    homepage = "http://github.com/baskerville/bspwm";
    maintainers = stdenv.lib.maintainers.meisternu;
    license = "BSD";
    platforms = stdenv.lib.platforms.linux;
  };
}
