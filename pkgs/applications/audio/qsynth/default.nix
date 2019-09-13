{ stdenv, fetchurl, alsaLib, fluidsynth, libjack2, qt5, autoconf, pkgconfig }:

stdenv.mkDerivation  rec {
  pname = "qsynth";
  version = "0.5.7";

  src = fetchurl {
    url = "mirror://sourceforge/qsynth/${pname}-${version}.tar.gz";
    sha256 = "18im4w8agj60nkppwbkxqnhpp13z5li3w30kklv4lgs20rvgbvl6";
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
