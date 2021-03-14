{ lib, stdenv, fetchFromGitHub , cmake, libjack2, libsndfile, pkg-config }:

stdenv.mkDerivation rec {
  pname = "sfizz";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "sfztools";
    repo = pname;
    rev = version;
    sha256 = "0zpmvmh7n0064rxfqxb7z9rnz493k7yq7nl0vxppqnasg97jn5f3";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ libjack2 libsndfile ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DSFIZZ_TESTS=ON"
  ];

  meta = with lib; {
    homepage = "https://github.com/sfztools/sfizz";
    description = "SFZ jack client and LV2 plugin";
    license = licenses.bsd2;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.all;
    badPlatforms = platforms.darwin;
  };
}
