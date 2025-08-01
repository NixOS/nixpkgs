{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kassert";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "kamping-site";
    repo = "kassert";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5UndFUhKtHPFPLfYP0EI/r+eoAptcQBheznALfxh27s=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    # doc generation require git clone doxygen-awesome-css
    (lib.cmakeBool "KASSERT_BUILD_DOCS" false)
    (lib.cmakeBool "KASSERT_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "KASSERT_USE_BUNDLED_GTEST" false)
  ];

  doCheck = true;

  nativeCheckInputs = [ gtest ];

  meta = {
    description = "Karlsruhe assertion library for C++";
    homepage = "https://kamping-site.github.io/kassert/";
    downloadPage = "https://github.com/kamping-site/kassert";
    changelog = "https://github.com/kamping-site/kasser/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [ mit ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ qbisi ];
  };
})
