{
  lib,
  fetchurl,
  pkg-config,
  libjack2,
  alsa-lib,
  libsndfile,
  liblo,
  lv2,
  qt5,
  fftwFloat,
  mkDerivation,
}:

mkDerivation rec {
  pname = "padthv1";
  version = "0.9.23";

  src = fetchurl {
    url = "mirror://sourceforge/padthv1/${pname}-${version}.tar.gz";
    sha256 = "sha256-9yFfvlskOYnGraou2S3Qffl8RoYJqE0wnDlOP8mxQgg=";
  };

  buildInputs = [
    libjack2
    alsa-lib
    libsndfile
    liblo
    lv2
    qt5.qtbase
    qt5.qttools
    fftwFloat
  ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "polyphonic additive synthesizer";
    mainProgram = "padthv1_jack";
    homepage = "http://padthv1.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.magnetophon ];
  };
}
