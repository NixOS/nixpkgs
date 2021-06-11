{ lib, fetchurl, pkg-config, libjack2, alsa-lib, libsndfile, liblo, lv2, qt5, fftwFloat, mkDerivation }:

mkDerivation rec {
  pname = "padthv1";
  version = "0.9.18";

  src = fetchurl {
    url = "mirror://sourceforge/padthv1/${pname}-${version}.tar.gz";
    sha256 = "1karrprb3ijrbiwpr43rl3nxnzc33lnmwrd1832psgr3flnr9fp5";
  };

  buildInputs = [ libjack2 alsa-lib libsndfile liblo lv2 qt5.qtbase qt5.qttools fftwFloat ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "polyphonic additive synthesizer";
    homepage = "http://padthv1.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.magnetophon ];
  };
}
