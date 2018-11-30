{ stdenv, fetchurl, pkgconfig, qt5, libjack2, alsaLib, liblo, lv2 }:

stdenv.mkDerivation rec {
  name = "synthv1-${version}";
  version = "0.9.3";

  src = fetchurl {
    url = "mirror://sourceforge/synthv1/${name}.tar.gz";
    sha256 = "0f58k5n2k667q8wsigg7bzl3lfgaf6jdj98r2a5nvyb18v1wpy2c";
  };

  buildInputs = [ qt5.qtbase qt5.qttools libjack2 alsaLib liblo lv2 ];

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "An old-school 4-oscillator subtractive polyphonic synthesizer with stereo fx";
    homepage = https://synthv1.sourceforge.io/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
