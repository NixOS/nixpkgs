{ stdenv, fetchurl, libxcb, libXinerama, sxhkd, xcbutil, xcbutilkeysyms, xcbutilwm }:

stdenv.mkDerivation rec {
  name = "bspwm-${version}";
  version = "0.9.1";


  src = fetchurl {
    url = "https://github.com/baskerville/bspwm/archive/${version}.tar.gz";
    sha256 = "11dvfcvr8bc116yb3pvl0k1h2gfm9rv652jbxd1c5pmc0yimifq2";
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
