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

stdenv.mkDerivation rec {
  pname = "ftxui";
  version = "6.1.9";

  src = fetchFromGitHub {
    owner = "ArthurSonzogni";
    repo = "ftxui";
    tag = "v${version}";
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

  cmakeFlags = [
    (lib.cmakeBool "FTXUI_BUILD_EXAMPLES" false)
    (lib.cmakeBool "FTXUI_BUILD_DOCS" true)
    (lib.cmakeBool "FTXUI_BUILD_TESTS" doCheck)
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  meta = {
    homepage = "https://github.com/ArthurSonzogni/FTXUI";
    changelog = "https://github.com/ArthurSonzogni/FTXUI/blob/v${version}/CHANGELOG.md";
    description = "Functional Terminal User Interface library for C++";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
