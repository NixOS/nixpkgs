{ stdenv, fetchurl, alsaLib, fluidsynth, libjack2, qt5, autoconf, pkgconfig }:

stdenv.mkDerivation  rec {
  name = "qsynth-${version}";
  version = "0.5.6";

  src = fetchurl {
    url = "mirror://sourceforge/qsynth/${name}.tar.gz";
    sha256 = "0h4hhja8qbyzd6v24flw9wr4mwl03nplryx1gyrppn7sg13l1sx6";
  };

  nativeBuildInputs = [ autoconf pkgconfig ];

  buildInputs = [ alsaLib fluidsynth libjack2 qt5.qtbase qt5.qttools qt5.qtx11extras ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Fluidsynth GUI";
    homepage = https://sourceforge.net/projects/qsynth;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.linux;
  };
}
