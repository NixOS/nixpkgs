{ mkDerivation, stdenv, fetchurl, pkgconfig, qtbase, qttools, libjack2, alsaLib, liblo, lv2 }:

mkDerivation rec {
  pname = "synthv1";
  version = "0.9.14";

  src = fetchurl {
    url = "mirror://sourceforge/synthv1/${pname}-${version}.tar.gz";
    sha256 = "08n83krkak20924flb9azhm9hn40lyfvn29m63zs3lw3wajf0b40";
  };

  buildInputs = [ qtbase qttools libjack2 alsaLib liblo lv2 ];

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "An old-school 4-oscillator subtractive polyphonic synthesizer with stereo fx";
    homepage = "https://synthv1.sourceforge.io/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
