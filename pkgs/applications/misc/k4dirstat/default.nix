{
  lib,
  stdenv,
  fetchFromGitHub,
  extra-cmake-modules,
  wrapQtAppsHook,
  kiconthemes,
  kio,
  kjobwidgets,
  kxmlgui,
  testers,
  k4dirstat,
}:

stdenv.mkDerivation rec {
  pname = "k4dirstat";
  version = "3.4.3";

  src = fetchFromGitHub {
    owner = "jeromerobert";
    repo = "k4dirstat";
    rev = version;
    hash = "sha256-TXMUtiPS7qRLm6cCy2ZntYrcNJ0fn6X+3o3P5u7oo08=";
  };

  nativeBuildInputs = [
    extra-cmake-modules
    wrapQtAppsHook
  ];

  buildInputs = [
    kiconthemes
    kio
    kjobwidgets
    kxmlgui
  ];

  passthru.tests.version = testers.testVersion {
    package = k4dirstat;
    command = "k4dirstat -platform offscreen --version &>/dev/stdout";
  };

  meta = {
    homepage = "https://github.com/jeromerobert/k4dirstat";
    description = "Small utility program that sums up disk usage for directory trees";
    mainProgram = "k4dirstat";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.raboof ];
    platforms = lib.platforms.linux;
  };
}
