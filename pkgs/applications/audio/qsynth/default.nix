{ stdenv, fetchurl, alsaLib, fluidsynth, libjack2, qtbase, qttools, qtx11extras, cmake, pkgconfig }:

stdenv.mkDerivation  rec {
  name = "qsynth-${version}";
  version = "0.5.0";

  src = fetchurl {
    url = "mirror://sourceforge/qsynth/${name}.tar.gz";
    sha256 = "1sr6vrz8z9r99j9xcix86lgcqldragb2ajmq1bnhr58d99sda584";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ alsaLib fluidsynth libjack2 qtbase qttools qtx11extras ];

  meta = with stdenv.lib; {
    description = "Fluidsynth GUI";
    homepage = https://sourceforge.net/projects/qsynth;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
