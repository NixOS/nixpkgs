{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  enableAvx2 ? false,
}:

stdenv.mkDerivation (final: {
  pname = "glaze";
  version = "5.5.5";

  src = fetchFromGitHub {
    owner = "stephenberry";
    repo = "glaze";
    tag = "v${final.version}";
    hash = "sha256-vFAMS4sZ3/KKeKHGzTnTujh076eML35bWqxUuzTap+8=";
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
