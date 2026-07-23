{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  extra-cmake-modules,
  wrapQtAppsHook,
  shared-mime-info,
  xz,
  qttools,
  karchive,
  kcmutils,
  kconfig,
  kconfigwidgets,
  kcrash,
  knewstuff,
  kparts,
  qca,
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
    extra-cmake-modules
    wrapQtAppsHook
  ];

  buildInputs = [
    shared-mime-info
    xz

    qttools

    karchive
    kcmutils
    kconfig
    kconfigwidgets
    kcrash
    knewstuff
    kparts
    qca
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
