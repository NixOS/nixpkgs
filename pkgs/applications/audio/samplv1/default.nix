{ mkDerivation, lib, fetchurl, pkg-config, libjack2
, alsa-lib, liblo, libsndfile, lv2, qtbase, qttools
, rubberband
}:

mkDerivation rec {
  pname = "samplv1";
  version = "0.9.23";

  src = fetchurl {
    url = "mirror://sourceforge/samplv1/${pname}-${version}.tar.gz";
    sha256 = "sha256-eJA6ixH20Wv+cD2CKGomncyfJ4tfpOL3UrTeCkb5/q0=";
  };

  nativeBuildInputs = [ qttools pkg-config ];

  buildInputs = [ libjack2 alsa-lib liblo libsndfile lv2 qtbase rubberband ];

  meta = with lib; {
    description = "Old-school all-digital polyphonic sampler synthesizer with stereo fx";
    mainProgram = "samplv1_jack";
    homepage = "http://samplv1.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
