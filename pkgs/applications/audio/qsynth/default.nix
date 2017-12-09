{ stdenv, fetchurl, alsaLib, fluidsynth, libjack2, qtbase, qttools, qtx11extras, cmake, pkgconfig }:

stdenv.mkDerivation  rec {
  name = "qsynth-${version}";
  version = "0.4.4";

  src = fetchurl {
    url = "mirror://sourceforge/qsynth/${name}.tar.gz";
    sha256 = "0qhfnikx3xcllkvs60kj6vcf2rwwzh31y41qkk6kwfhzgd219y8f";
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
