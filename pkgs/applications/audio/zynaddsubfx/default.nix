{ stdenv, fetchurl, alsaLib, fftw, fltk, minixml, zlib }:

stdenv.mkDerivation  rec {
  name = "zynaddsubfx-${version}";
  version = "2.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/zynaddsubfx/ZynAddSubFX-${version}.tar.bz2";
    sha256 = "1zn5lgh76rrbfj8d4jys2gc1j2pqrbdd18ywfdrk0s7jq4inwyfg";
  };

  buildInputs = [ alsaLib fftw fltk minixml zlib ];

  preConfigure = "cd src";

  installPhase = "mkdir -p $out/bin; cp zynaddsubfx $out/bin";

  meta = with stdenv.lib; {
    description = "high quality software synthesizer";
    homepage = http://zynaddsubfx.sourceforge.net;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
