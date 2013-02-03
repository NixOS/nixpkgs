{ stdenv, fetchgit, fftwSinglePrec, libxslt, lv2, pkgconfig }:

let
  rev = "ec6b85e19e24ed";
in
stdenv.mkDerivation rec {
  name = "swh-lv2-${rev}";

  src = fetchgit {
    url = "git://github.com/swh/lv2.git";
    inherit rev;
    sha256 = "d0d918ee642cd9649215737fcc008ce2bf55f4ea893a1897138b33775ea60d17";
  };

  patchPhase = ''
    sed -e "s#xsltproc#${libxslt}/bin/xsltproc#" -i Makefile
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
