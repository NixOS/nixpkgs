{
  stdenv,
  lib,
  fetchFromGitLab,
  cmake,
  qt6,
  kdePackages,
  ghostscript,
  qpdf,
  ninja,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "karp";
  version = "0-unstable-2025-01-24";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "graphics";
    repo = "karp";
    rev = "44b2e88b3c1ac5f1b37ec4080d068bf83c8328ca";
    hash = "sha256-w9Mtw7T4LOYML0A64ctE4g6m9IaNRHidt23ZsqwUwac=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    qt6.wrapQtAppsHook
    kdePackages.extra-cmake-modules
  ];

  qtWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        qpdf
        ghostscript
      ]
    }"
  ];

  buildInputs = [
    qt6.qtbase
    kdePackages.kirigami
    kdePackages.kirigami-addons
    kdePackages.kcoreaddons
    kdePackages.kconfig
    kdePackages.ki18n
    kdePackages.kcrash
    qt6.qtdeclarative
    qt6.qtwayland
    qt6.qtsvg
    qpdf
    qt6.qtwebengine
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://apps.kde.org/karp/";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    description = "KDE alternative to PDF arranger";
    license = with lib.licenses; [
      bsd3
      cc-by-sa-40
      cc0
      # FSFAP
      gpl2Only
      gpl3Only
      lgpl2Plus
      # https://invent.kde.org/graphics/karp/-/blob/master/LICENSES/LicenseRef-KDE-Accepted-GPL.txt
    ];
    mainProgram = "karp";
  };
}
