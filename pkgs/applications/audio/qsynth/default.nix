{ lib, stdenv, fetchurl, alsaLib, fluidsynth, libjack2, autoconf, pkg-config
, mkDerivation, qtbase, qttools, qtx11extras
}:

mkDerivation  rec {
  pname = "qsynth";
  version = "0.6.3";

  src = fetchurl {
    url = "mirror://sourceforge/qsynth/${pname}-${version}.tar.gz";
    sha256 = "0xiqmpzpxjvh32vivfj6h33w0ahmyfjzjb41b6fnf92bbg9k6mqv";
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
