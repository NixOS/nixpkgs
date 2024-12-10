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
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "OpenPathGuidingLibrary";
    repo = "openpgl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dbHmGGiHQkU0KPpQYpY/o0uCWdb3L5namETdOcOREgs=";
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
    stdenv.isAarch64 && !stdenv.isDarwin
  ) "-flax-vector-conversions";

  meta = {
    description = "Intel Open Path Guiding Library";
    homepage = "https://github.com/OpenPathGuidingLibrary/openpgl";
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.amarshall ];
    license = lib.licenses.asl20;
  };
})
