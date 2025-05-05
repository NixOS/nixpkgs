{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  enableAvx2 ? false,
}:

stdenv.mkDerivation (final: {
  pname = "glaze";
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "stephenberry";
    repo = "glaze";
    rev = "v${final.version}";
    hash = "sha256-1Mk/BaU1D4SASC47pHlfno6n39WR5lUVPtboqz70+4s=";
  };

  nativeBuildInputs = [ cmake ];
  cmakeFlags = [ (lib.cmakeBool "glaze_ENABLE_AVX2" enableAvx2) ];

  meta = with lib; {
    description = "Extremely fast, in memory, JSON and interface library for modern C++";
    platforms = platforms.all;
    maintainers = with maintainers; [ moni ];
    license = licenses.mit;
  };
})
