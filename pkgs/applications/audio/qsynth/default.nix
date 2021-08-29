{ lib, fetchurl, alsaLib, fluidsynth, libjack2, autoconf, pkg-config
, mkDerivation, qtbase, qttools, qtx11extras
}:

mkDerivation  rec {
  pname = "qsynth";
  version = "0.9.1";

  src = fetchurl {
    url = "mirror://sourceforge/qsynth/${pname}-${version}.tar.gz";
    sha256 = "sha256-VNcI5QOVacHBcI6psEvhm7+cOTpwr2pMVXmk7nMXNiY=";
  };

  nativeBuildInputs = [ autoconf pkg-config ];

  buildInputs = [ alsaLib fluidsynth libjack2 qtbase qttools qtx11extras ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Fluidsynth GUI";
    homepage = "https://sourceforge.net/projects/qsynth";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.linux;
  };
}
