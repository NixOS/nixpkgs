{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  enableAvx2 ? false,
}:

stdenv.mkDerivation (final: {
  pname = "glaze";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "stephenberry";
    repo = "glaze";
    tag = "v${final.version}";
    hash = "sha256-4bEBnPLp7v6Jrd8h6q5LJc93om2VP3ZqB4JNSpKzPao=";
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
