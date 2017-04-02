{ stdenv, fetchurl, libxcb, libXinerama, sxhkd, xcbutil, xcbutilkeysyms, xcbutilwm }:

stdenv.mkDerivation rec {
  name = "bspwm-${version}";
  version = "0.9.2";


  src = fetchurl {
    url = "https://github.com/baskerville/bspwm/archive/${version}.tar.gz";
    sha256 = "1w6wxwgyb14w664xafp3b2ps6zzf9yw7cfhbh9229x2hil9rss1k";
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
