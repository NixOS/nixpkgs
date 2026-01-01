{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
<<<<<<< HEAD
  qt6,
=======
  libsForQt5,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

stdenv.mkDerivation {
  pname = "glabels-qt";
<<<<<<< HEAD
  version = "unstable-2025-12-03";
=======
  version = "unstable-2021-02-06";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "jimevins";
    repo = "glabels-qt";
<<<<<<< HEAD
    tag = "3.99-master602";
    hash = "sha256-7MQufoU1GBvmZd8FRn331/PwmwQMuZeuFKQqViRI754=";
=======
    rev = "glabels-3.99-master564";
    hash = "sha256-SdNOkjspqf6NuuIBZDsJneY6PNrIiP4HU46wDpBLt9Y=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cmake
<<<<<<< HEAD
    qt6.wrapQtAppsHook
    qt6.qttools
  ];

  meta = {
    description = "GLabels Label Designer (Qt/C++)";
    homepage = "https://github.com/jimevins/glabels-qt";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.matthewcroughan ];
=======
    libsForQt5.wrapQtAppsHook
    libsForQt5.qttools
  ];

  meta = with lib; {
    description = "GLabels Label Designer (Qt/C++)";
    homepage = "https://github.com/jimevins/glabels-qt";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.matthewcroughan ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = lib.platforms.linux;
  };
}
