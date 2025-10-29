{
  stdenv,
  lib,
  cmake,
  fetchFromGitHub,
  boost,
}:

stdenv.mkDerivation rec {
  pname = "boost-sml";
  version = "1.1.12";

  src = fetchFromGitHub {
    owner = "boost-ext";
    repo = "sml";
    rev = "v${version}";
    hash = "sha256-IvZwkhZe9pcyJhZdn4VkWMRUN6Ow8qs3zB6JtWb5pKk=";
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

  meta = {
    description = "Header only state machine library with no dependencies";
    homepage = "https://github.com/boost-ext/sml";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ prtzl ];
    platforms = lib.platforms.all;
  };
}
