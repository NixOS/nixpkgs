{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  qrencode,
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

  strictDeps = true;
  __structuredAttrs = true;

  buildInputs = [
    qt6.qttools
  ];

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  meta = {
    description = "GLabels Label Designer (Qt/C++)";
    homepage = "https://github.com/j-evins/glabels-qt";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.matthewcroughan ];
    platforms = lib.platforms.linux;
  };
}
