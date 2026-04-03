{
  lib,
  stdenv,
  adwaita-qt6,
  appstream-glib,
  cmake,
  fetchFromGitHub,
  qt6,
  udisks,
  xz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mediawriter";
  version = "5.3.0";

  src = fetchFromGitHub {
    owner = "FedoraQt";
    repo = "MediaWriter";
    tag = finalAttrs.version;
    hash = "sha256-oicnUxyo+5nuDh7A3oL9Pgrm69Lv7CWeNaJdMfuESu8=";
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
    udisks
    xz
  ];

  meta = {
    description = "Tool to write images files to portable media";
    homepage = "https://github.com/FedoraQt/MediaWriter";
    changelog = "https://github.com/FedoraQt/MediaWriter/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl2Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "mediawriter";
  };
})
