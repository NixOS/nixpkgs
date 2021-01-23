{ mkDerivation, lib, fetchurl, pkg-config, libjack2
, alsaLib, liblo, libsndfile, lv2, qtbase, qttools
, rubberband
}:

mkDerivation rec {
  pname = "samplv1";
  version = "0.9.18";

  src = fetchurl {
    url = "mirror://sourceforge/samplv1/${pname}-${version}.tar.gz";
    sha256 = "ePhM9OTLJp1Wa2D9Y1Dqq/69WlEhEp3ih9yNUIJU5Y4=";
  };

  nativeBuildInputs = [ qttools pkg-config ];

  buildInputs = [ libjack2 alsaLib liblo libsndfile lv2 qtbase rubberband ];

  meta = with lib; {
    description = "An old-school all-digital polyphonic sampler synthesizer with stereo fx";
    homepage = "http://samplv1.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
