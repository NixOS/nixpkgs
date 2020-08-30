{ stdenv, fetchFromGitLab, cmake, pkg-config, redkite, libsndfile, rapidjson, libjack2, lv2, libX11, cairo }:

stdenv.mkDerivation rec {
  pname = "geonkick";
  version = "2.3.7";

  src = fetchFromGitLab {
    owner = "iurie-sw";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wdcbwiyy6i5agq5lffkyilyc8mv1cc4mp9h0nybn240vb2flqc2";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ redkite libsndfile rapidjson libjack2 lv2 libX11 cairo ];

  # https://github.com/iurie-sw/geonkick/issues/120
  cmakeFlags = [ "-DGKICK_REDKITE_SDK_PATH=${redkite}" "-DCMAKE_INSTALL_LIBDIR=lib" ];

  meta = {
    homepage = "https://gitlab.com/iurie-sw/geonkick";
    description = "A free software percussion synthesizer";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
  };
}
