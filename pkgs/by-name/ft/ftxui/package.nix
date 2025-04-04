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
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "ArthurSonzogni";
    repo = "ftxui";
    rev = "v${version}";
    sha256 = "sha256-VvP1ctFlkTDdrAGRERBxMRpFuM4mVpswR/HO9dzUSUo=";
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
    "-DFTXUI_BUILD_EXAMPLES=OFF"
    "-DFTXUI_BUILD_DOCS=ON"
    "-DFTXUI_BUILD_TESTS=${if doCheck then "ON" else "OFF"}"
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  meta = with lib; {
    homepage = "https://github.com/ArthurSonzogni/FTXUI";
    changelog = "https://github.com/ArthurSonzogni/FTXUI/blob/v${version}/CHANGELOG.md";
    description = "Functional Terminal User Interface library for C++";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
