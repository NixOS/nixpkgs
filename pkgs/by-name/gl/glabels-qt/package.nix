{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
}:

stdenv.mkDerivation {
  pname = "glabels-qt";
  version = "0-unstable-2026-05-24";

  src = fetchFromGitHub {
    owner = "j-evins";
    repo = "glabels-qt";
    tag = "3.99-master638";
    hash = "sha256-oi9WOzt3o+5QpfHeosCnbvDmLirE7jXaQUJ5ADd3LY4=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
    qt6.qttools
  ];

  meta = {
    description = "GLabels Label Designer (Qt/C++)";
    homepage = "https://github.com/j-evins/glabels-qt";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.matthewcroughan ];
    platforms = lib.platforms.linux;
  };
}
