{ stdenv, fetchurl, alsaLib, cmake, fftw, fltk13, minixml, pkgconfig, zlib }:

stdenv.mkDerivation  rec {
  name = "zynaddsubfx-${version}";
  version = "2.4.3";

  src = fetchurl {
    url = "mirror://sourceforge/zynaddsubfx/ZynAddSubFX-${version}.tar.bz2";
    sha256 = "0kgmwyh4rhyqdfrdzhbzjjk2hzggkp9c4aac6sy3xv6cc1b5jjxq";
  };

  buildInputs = [ alsaLib fftw fltk13 minixml zlib ];
  nativeBuildInputs = [ cmake pkgconfig ];

  patches = [
    (fetchurl {
      url = http://patch-tracker.debian.org/patch/series/dl/zynaddsubfx/2.4.0-1.2/09_fluid_1.3.patch;
      sha256 = "06wl7fs44b24ls1fzh21596n6zzc3ywm2bcdfrkfiiwpzin3yjq6";
    })
  ];

#installPhase = "mkdir -pv $out/bin; cp -v zynaddsubfx $out/bin";

  meta = with stdenv.lib; {
    description = "high quality software synthesizer";
    homepage = http://zynaddsubfx.sourceforge.net;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
