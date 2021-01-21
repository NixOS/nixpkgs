{ mkDerivation, lib, fetchurl, pkg-config, libjack2, alsaLib, libsndfile, liblo, lv2, qt5 }:

mkDerivation rec {
  pname = "drumkv1";
  version = "0.9.19";

  src = fetchurl {
    url = "mirror://sourceforge/drumkv1/${pname}-${version}.tar.gz";
    sha256 = "sha256-LmOUXI9tBlUMeBfHzW4KjtDTjWtfE8Q8qOJ5MgzLLnE=";
  };

  buildInputs = [ libjack2 alsaLib libsndfile liblo lv2 qt5.qtbase qt5.qttools ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "An old-school drum-kit sampler synthesizer with stereo fx";
    homepage = "http://drumkv1.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
