{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  nix-update-script,
  kdePackages,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "kara";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "dhruv8sh";
    repo = "kara";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nOMsR9bocDVwH1wB+tGu7y4hnvcAUVTNPXrAzcmws3w=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
  ];

  buildInputs = with kdePackages; [
    qtbase
    qtdeclarative
    ki18n
    kservice
    kwindowsystem
    libplasma
    plasma-activities
    kwin
    plasma-workspace
  ];

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeFeature "Qt6_DIR" "${kdePackages.qtbase}/lib/cmake/Qt6")
  ];

  dontWrapQtApps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "KDE Plasma Applet for use as a desktop/workspace pager";
    homepage = "https://github.com/dhruv8sh/kara";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    inherit (kdePackages.kwindowsystem.meta) platforms;
  };
})
