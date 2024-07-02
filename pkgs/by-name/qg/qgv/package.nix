{
  stdenv,
  fetchFromGitHub,
  lib,
  cmake,
  graphviz,
  jrl-cmakemodules,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qgv";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "gepetto";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-NUMCVqXw7euwxm4vISU8qYFfvV5HbAJsj/IjyxEjCPw=";
  };

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qttools
  ];

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
  ];

  propagatedBuildInputs = [
    graphviz
    jrl-cmakemodules
  ];

  meta = {
    description = "Interactive Qt graphViz display";
    homepage = "https://github.com/gepetto/qgv";
    license = lib.licenses.lgpl3Only;
    maintainers = [ lib.maintainers.nim65s ];
  };
})
