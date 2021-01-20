{ lib, stdenv, fetchurl, pkg-config, libjack2, alsaLib, libsndfile, liblo, lv2, qt5, fftwFloat, mkDerivation }:

mkDerivation rec {
  pname = "padthv1";
  version = "0.9.19";

  src = fetchurl {
    url = "mirror://sourceforge/padthv1/${pname}-${version}.tar.gz";
    sha256 = "sha256-J5s7xddESaAoMHaNlArtYCZMKpuWmsOG0iP/3gnL0xk=";
  };

  buildInputs = [ libjack2 alsaLib libsndfile liblo lv2 qt5.qtbase qt5.qttools fftwFloat ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "polyphonic additive synthesizer";
    homepage = "http://padthv1.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.magnetophon ];
  };
}
