{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  doxygen,
  gbenchmark,
  graphviz,
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ftxui";
  version = "6.1.9";

  src = fetchFromGitHub {
    owner = "ArthurSonzogni";
    repo = "ftxui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-plJxTLhOhUyuay5uYv4KLK9UTmM2vsoda+iDXVa4b+k=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
  ];

  checkInputs = [
    gtest
    gbenchmark
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  cmakeFlags = [
    (lib.cmakeBool "FTXUI_BUILD_EXAMPLES" false)
    (lib.cmakeBool "FTXUI_BUILD_DOCS" true)
    (lib.cmakeBool "FTXUI_BUILD_TESTS" finalAttrs.doCheck)
  ];

  meta = {
    homepage = "https://github.com/ArthurSonzogni/FTXUI";
    changelog = "https://github.com/ArthurSonzogni/FTXUI/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Functional Terminal User Interface library for C++";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ phanirithvij ];
    platforms = lib.platforms.all;
  };
})
