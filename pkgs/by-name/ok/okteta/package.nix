{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  shared-mime-info,
  xz,
  kdePackages,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "okteta";
  version = "0.26.25-unstable-2026-04-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "utilities";
    repo = "okteta";
    rev = "9ab055f50e7569c9a0bc401be4b5686dc1e61dcc";
    hash = "sha256-1ih0kFS7opA5w1QyB7MQAOYFoSAUPKNM8fRi1G/mq2U=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    shared-mime-info
    xz

    qt6.qttools

    kdePackages.karchive
    kdePackages.kcmutils
    kdePackages.kconfig
    kdePackages.kconfigwidgets
    kdePackages.kcrash
    kdePackages.knewstuff
    kdePackages.kparts
    kdePackages.qca
  ];

  outputs = [
    "out"
    "dev"
  ];

  meta = {
    license = lib.licenses.gpl2;
    description = "Hex editor";
    homepage = "https://apps.kde.org/okteta/";
    maintainers = with lib.maintainers; [
      peterhoeg
      bkchr
    ];
    platforms = lib.platforms.linux;
  };
})
