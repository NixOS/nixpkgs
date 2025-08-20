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
}:

stdenv.mkDerivation {
  pname = "karp";
  version = "0-unstable-2024-11-20";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "graphics";
    repo = "karp";
    rev = "f26d6c43adc2feb2b0569df126f3a7be5d95ac2e";
    hash = "sha256-w1wrPaqQ6NBtbY5OEtxGlc72mXuLrlefq6A02U9wWHc=";
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
    qt6.qtdeclarative
    qt6.qtwayland
    qt6.qtsvg
    qt6.qtwebengine
  ];

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
