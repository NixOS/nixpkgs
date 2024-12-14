{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  enableAvx2 ? false,
}:

stdenv.mkDerivation (final: {
  pname = "glaze";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "stephenberry";
    repo = "glaze";
    rev = "v${final.version}";
    hash = "sha256-fNarN2VFgfZDmY62EoLsiMdW60XPbi71wbiSe/ftaFc=";
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
