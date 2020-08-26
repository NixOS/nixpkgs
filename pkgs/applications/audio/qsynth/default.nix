{ stdenv, fetchurl, alsaLib, fluidsynth, libjack2, autoconf, pkgconfig
, mkDerivation, qtbase, qttools, qtx11extras
}:

mkDerivation  rec {
  pname = "qsynth";
  version = "0.6.2";

  src = fetchurl {
    url = "mirror://sourceforge/qsynth/${pname}-${version}.tar.gz";
    sha256 = "0cp6vrqrj37rv3a7qfvqrg64j7zwpfj60y5b83mlkzvmg1sgjnlv";
  };

  nativeBuildInputs = [ autoconf pkgconfig ];

  buildInputs = [ alsaLib fluidsynth libjack2 qtbase qttools qtx11extras ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Fluidsynth GUI";
    homepage = "https://sourceforge.net/projects/qsynth";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.linux;
  };
}
