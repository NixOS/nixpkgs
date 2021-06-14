{ mkDerivation, lib, fetchurl, pkg-config, libjack2
, alsa-lib, liblo, libsndfile, lv2, qtbase, qttools
, rubberband
}:

mkDerivation rec {
  pname = "samplv1";
  version = "0.9.20";

  src = fetchurl {
    url = "mirror://sourceforge/samplv1/${pname}-${version}.tar.gz";
    sha256 = "sha256-9tm72lV9i/155TVweNwO2jpPsCJkh6r82g7Z1wCI1ho=";
  };

  nativeBuildInputs = [ qttools pkg-config ];

  buildInputs = [ libjack2 alsa-lib liblo libsndfile lv2 qtbase rubberband ];

  meta = with lib; {
    description = "An old-school all-digital polyphonic sampler synthesizer with stereo fx";
    homepage = "http://samplv1.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
