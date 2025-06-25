{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  enableAvx2 ? false,
}:

stdenv.mkDerivation (final: {
  pname = "glaze";
  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "stephenberry";
    repo = "glaze";
    tag = "v${final.version}";
    hash = "sha256-HC8R1wyNySVhuTZczdbiHkQ8STTXA/1GJLKdTXN9VAo=";
  };

  nativeBuildInputs = [ cmake ];
  cmakeFlags = [ (lib.cmakeBool "glaze_ENABLE_AVX2" enableAvx2) ];

  meta = {
    description = "Extremely fast, in memory, JSON and interface library for modern C++";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ moni ];
    license = lib.licenses.mit;
  };
})
