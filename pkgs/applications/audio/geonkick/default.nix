{ stdenv, fetchFromGitLab, cmake, pkg-config, redkite, libsndfile, rapidjson
, libjack2, lv2, libX11, cairo }:

stdenv.mkDerivation rec {
  pname = "geonkick";
  version = "2.5.0";

  src = fetchFromGitLab {
    owner = "iurie-sw";
    repo = pname;
    rev = "v${version}";
    sha256 = "19zbz4v2n5ph4af721xls7ignmis2q2yqyd0m97g9b3njrgnfy3n";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ redkite libsndfile rapidjson libjack2 lv2 libX11 cairo ];

  # https://github.com/iurie-sw/geonkick/issues/120
  cmakeFlags = [
    "-DGKICK_REDKITE_SDK_PATH=${redkite}"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  meta = with stdenv.lib; {
    homepage = "https://gitlab.com/iurie-sw/geonkick";
    description = "A free software percussion synthesizer";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.magnetophon ];
  };
}
