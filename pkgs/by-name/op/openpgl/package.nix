{
  lib,
  cmake,
  fetchFromGitHub,
  ninja,
  stdenv,
  tbb,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openpgl";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "OpenPathGuidingLibrary";
    repo = "openpgl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HX3X1dmOazUUiYCqa6irpNm37YthB2YHb8u1P1qDHco=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    tbb
  ];

  cmakeFlags = [
    "-DOPENPGL_BUILD_STATIC=OFF"
    "-DTBB_ROOT=${tbb.out}"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString (
    stdenv.hostPlatform.isAarch64 && !stdenv.hostPlatform.isDarwin
  ) "-flax-vector-conversions";

  meta = {
    description = "Intel Open Path Guiding Library";
    homepage = "https://github.com/OpenPathGuidingLibrary/openpgl";
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.amarshall ];
    license = lib.licenses.asl20;
  };
})
