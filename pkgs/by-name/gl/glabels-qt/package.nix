{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
}:

stdenv.mkDerivation {
  pname = "glabels-qt";
  version = "unstable-2025-12-03";

  src = fetchFromGitHub {
    owner = "jimevins";
    repo = "glabels-qt";
    tag = "3.99-master602";
    hash = "sha256-7MQufoU1GBvmZd8FRn331/PwmwQMuZeuFKQqViRI754=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
    qt6.qttools
  ];

  meta = {
    description = "GLabels Label Designer (Qt/C++)";
    homepage = "https://github.com/jimevins/glabels-qt";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.matthewcroughan ];
    platforms = lib.platforms.linux;
  };
}
