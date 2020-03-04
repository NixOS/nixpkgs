{ mkDerivation, stdenv, fetchurl, pkgconfig, qtbase, qttools, libjack2, alsaLib, liblo, lv2 }:

mkDerivation rec {
  pname = "synthv1";
  version = "0.9.12";

  src = fetchurl {
    url = "mirror://sourceforge/synthv1/${pname}-${version}.tar.gz";
    sha256 = "1amxrl1cqwgncw5437r572frgf6xhss3cfpbgh178i8phlq1q731";
  };

  buildInputs = [ qtbase qttools libjack2 alsaLib liblo lv2 ];

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "An old-school 4-oscillator subtractive polyphonic synthesizer with stereo fx";
    homepage = https://synthv1.sourceforge.io/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
