{
  stdenv,
  lib,
  cmake,
  fetchFromGitHub,
  boost,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "boost-sml";
  version = "1.1.13";

  src = fetchFromGitHub {
    owner = "boost-ext";
    repo = "sml";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VgJl09kCRCXBF/IraVbAVowrrMJH0NFcblQAKVQwl6w=";
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
})
