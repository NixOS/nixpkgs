{ mkDerivation, lib, fetchurl, pkg-config, libjack2, alsa-lib, libsndfile, liblo, lv2, qt5 }:

mkDerivation rec {
  pname = "drumkv1";
  version = "0.9.23";

  src = fetchurl {
    url = "mirror://sourceforge/drumkv1/${pname}-${version}.tar.gz";
    sha256 = "sha256-gNscsqGpEfU1CNJDlBAzum9M0vzJSm6Wx5b/zhOt+sk=";
  };

  buildInputs = [ libjack2 alsa-lib libsndfile liblo lv2 qt5.qtbase qt5.qttools ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Old-school drum-kit sampler synthesizer with stereo fx";
    mainProgram = "drumkv1_jack";
    homepage = "http://drumkv1.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
