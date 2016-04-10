{ stdenv, fetchgit, fftwSinglePrec, libxslt, lv2, pkgconfig }:

stdenv.mkDerivation rec {
  name = "swh-lv2-git-2013-05-17";

  src = fetchgit {
    url = "https://github.com/swh/lv2.git";
    rev = "978d5d8f549fd22048157a6d044af0faeaacbd7f";
    sha256 = "3a9c042785b856623339aedafa5bc019b41beb8034d8594c7bbd6c9c26368065";
  };

  patchPhase = ''
    sed -e "s#xsltproc#${libxslt.bin}/bin/xsltproc#" -i Makefile
    sed -e "s#PREFIX = /usr/local#PREFIX = $out#" -i Makefile
  '';

  buildInputs = [ fftwSinglePrec lv2 pkgconfig ];

  installPhase = "make install-system";

  meta = with stdenv.lib; {
    homepage = http://plugin.org.uk;
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
