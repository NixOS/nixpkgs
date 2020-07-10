{ stdenv, fetchFromGitHub , cmake, libjack2, libsndfile, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "sfizz";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "sfztools";
    repo = pname;
    rev = version;
    sha256 = "1px22x9lb6wyqfbv1jg1sbl1rsnwrzs8sm4dnas1w4ifchiv3ymd";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ libjack2 libsndfile ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DSFIZZ_TESTS=ON"
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/sfztools/sfizz";
    description = "SFZ jack client and LV2 plugin";
    license = licenses.bsd2;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.all;
    badPlatforms = platforms.darwin;
  };
}
