{ stdenv, fetchFromGitLab, cmake, pkg-config, redkite, libsndfile, rapidjson, libjack2, lv2, libX11, cairo }:

stdenv.mkDerivation rec {
  pname = "geonkick";
  version = "2.3.3";

  src = fetchFromGitLab {
    owner = "iurie-sw";
    repo = pname;
    rev = "v${version}";
    sha256 = "0h1abb6q2bmi01a3v37adkc4zc03j47jpvffz8p2lpp33xhljghs";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ redkite libsndfile rapidjson libjack2 lv2 libX11 cairo ];

  cmakeFlags = [ "-DGKICK_REDKITE_SDK_PATH=${redkite}" ];

  meta = {
    homepage = "https://gitlab.com/iurie-sw/geonkick";
    description = "A free software percussion synthesizer";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
  };
}
