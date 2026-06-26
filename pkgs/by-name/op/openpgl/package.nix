{
  lib,
  cmake,
  fetchFromGitHub,
  ninja,
  stdenv,
  onetbb,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openpgl";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "OpenPathGuidingLibrary";
    repo = "openpgl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3DZx+19t3ux3y1HplvrjF7QEhTH/pC+VlKdZhiUPbGI=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    onetbb
  ];

  cmakeFlags = [
    "-DOPENPGL_BUILD_STATIC=OFF"
    "-DTBB_ROOT=${onetbb.out}"
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
