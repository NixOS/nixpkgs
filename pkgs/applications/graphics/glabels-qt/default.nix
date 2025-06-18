{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libsForQt5,
}:

stdenv.mkDerivation {
  pname = "glabels-qt";
  version = "unstable-2021-02-06";

  src = fetchFromGitHub {
    owner = "jimevins";
    repo = "glabels-qt";
    rev = "glabels-3.99-master564";
    hash = "sha256-SdNOkjspqf6NuuIBZDsJneY6PNrIiP4HU46wDpBLt9Y=";
  };

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
    libsForQt5.qttools
  ];

  meta = with lib; {
    description = "GLabels Label Designer (Qt/C++)";
    homepage = "https://github.com/jimevins/glabels-qt";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.matthewcroughan ];
    platforms = lib.platforms.linux;
  };
}
