{
  stdenv,
  lib,
  cmake,
  fetchFromGitHub,
  boost,
}:

stdenv.mkDerivation rec {
  pname = "boost-sml";
  version = "1.1.11";

  src = fetchFromGitHub {
    owner = "boost-ext";
    repo = "sml";
    rev = "v${version}";
    hash = "sha256-/eR/B8rE+mh5zDPjx1kS9nVJf1rCeHP04QDavh6z6fM=";
  };

  buildInputs = [ boost ];
  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DSML_BUILD_BENCHMARKS=OFF"
    "-DSML_BUILD_EXAMPLES=OFF"
    "-DSML_BUILD_TESTS=ON"
    "-DSML_USE_EXCEPTIONS=ON"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Header only state machine library with no dependencies";
    homepage = "https://github.com/boost-ext/sml";
    license = licenses.boost;
    maintainers = with maintainers; [ prtzl ];
    platforms = platforms.all;
  };
}
