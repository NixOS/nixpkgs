{
  lib,
  stdenv,
  adwaita-qt6,
  appstream-glib,
  cmake,
  fetchFromGitHub,
  qt6,
  udisks2,
  xz,
}:

stdenv.mkDerivation rec {
  pname = "mediawriter";
  version = "5.2.5";

  src = fetchFromGitHub {
    owner = "FedoraQt";
    repo = "MediaWriter";
    tag = version;
    hash = "sha256-acKLKnAXTp1w8+pPVXO2gCi3GELEi3skYCYN13QjWyY=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  propagatedBuildInputs = [
    adwaita-qt6
    appstream-glib
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    udisks2
    xz
  ];

  meta = {
    description = "Tool to write images files to portable media";
    homepage = "https://github.com/FedoraQt/MediaWriter";
    changelog = "https://github.com/FedoraQt/MediaWriter/releases/tag/${version}";
    license = lib.licenses.lgpl2Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "mediawriter";
  };
}
