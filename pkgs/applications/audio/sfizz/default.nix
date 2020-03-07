{ stdenv, fetchFromGitHub , cmake, libjack2, libsndfile }:

stdenv.mkDerivation rec {
  pname = "sfizz";
  version = "unstable-2020-01-24";

  src = fetchFromGitHub {
    owner = "sfztools";
    repo = pname;
    rev = "b9c332777853cb35faeeda2ff4bf34ea7121ffb9";
    sha256 = "0wzgwpcwal5a7ifrm1hx8y6vx832qixk9ilp8wkjnsdxj6i88p2c";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

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
