{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
  qt6,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "crystal-dock";
<<<<<<< HEAD
  version = "2.16";
=======
  version = "2.15";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "dangvd";
    repo = "crystal-dock";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-UbRwD8BMw8JSRNtOBtHyULQjaXZRmkxmbTQD92v0BJI=";
=======
    hash = "sha256-XFq4T39El5MjaWRSnaimonjdj+HGOAydNmEOehgGWX4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.layer-shell-qt
    qt6.qtbase
    qt6.qtwayland
  ];

  cmakeDir = "../src";

<<<<<<< HEAD
  meta = {
    description = "Dock (desktop panel) for Linux desktop";
    mainProgram = "crystal-dock";
    license = lib.licenses.gpl3Only;
    homepage = "https://github.com/dangvd/crystal-dock";
    maintainers = with lib.maintainers; [ rafameou ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Dock (desktop panel) for Linux desktop";
    mainProgram = "crystal-dock";
    license = licenses.gpl3Only;
    homepage = "https://github.com/dangvd/crystal-dock";
    maintainers = with maintainers; [ rafameou ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
