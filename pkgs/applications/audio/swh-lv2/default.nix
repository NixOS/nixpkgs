{ lib, stdenv, fetchFromGitHub, fftwSinglePrec, libxslt, lv2, pkg-config }:

stdenv.mkDerivation rec {
  pname = "swh-lv2";
  version = "1.0.16";

  src = fetchFromGitHub {
    owner = "swh";
    repo = "lv2";
    rev = "v${version}";
    sha256 = "sha256-v6aJUWDbBZEmz0v6+cSCi/KhOYNUeK/MJLUSgzi39ng=";
  };

  patchPhase = ''
    sed -e "s#xsltproc#${libxslt.bin}/bin/xsltproc#" -i Makefile
    sed -e "s#PREFIX = /usr/local#PREFIX = $out#" -i Makefile
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ fftwSinglePrec lv2 ];

  installPhase = "make install-system";

  meta = with lib; {
    homepage = "http://plugin.org.uk";
    description = "LV2 version of Steve Harris' SWH plugins";
    longDescription = ''
      SWH plugins include:
      amp, fast overdrive, overdrive (with colourisation), comb
      filter, waveshaper, ringmod, divider, diode, decliper, pitch
      scaler, 16 band equaliser, sinus wavewrapper, hermes filter,
      chorus, flanger, decimater, oscillator, gverb, phasers, harmonic
      generators, surround encoders and more.
    '';
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
