{
  lib,
  stdenv,
  fetchFromGitHub,
<<<<<<< HEAD

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  cmake,
  doxygen,
  gbenchmark,
  graphviz,
  gtest,
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
=======
stdenv.mkDerivation rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "ftxui";
  version = "6.1.9";

  src = fetchFromGitHub {
    owner = "ArthurSonzogni";
    repo = "ftxui";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
=======
    tag = "v${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
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
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
