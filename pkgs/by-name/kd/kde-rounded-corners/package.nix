{
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
  libepoxy,
  libxcb,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kde-rounded-corners";
  version = "0.8.7";

  src = fetchFromGitHub {
    owner = "matinlotfali";
    repo = "KDE-Rounded-Corners";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ivWOMl0cveJHC6eX/QYteVi2GaRJ/2j02YlDj/Uvs1s=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];
  buildInputs = [
    kdePackages.kcmutils
    kdePackages.kwin
    libepoxy
    libxcb
    kdePackages.qtbase
  ];

  meta = {
    description = "Rounds the corners of your windows";
    homepage = "https://github.com/matinlotfali/KDE-Rounded-Corners";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ devusb ];
  };
})
