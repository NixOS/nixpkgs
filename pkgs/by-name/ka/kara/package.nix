{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
  kdePackages,
  cmake,
  qt6,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "kara";
  version = "0.8.0-unstable-2026-02-20";

  src = fetchFromGitHub {
    owner = "dhruv8sh";
    repo = "kara";
    rev = "2c9f7926d2da41324e9f56355be314a5c76fe022";
    hash = "sha256-SqFEtz4X9ZbzA4hEgHLDIqhQE0kuB6ht5i1gyFeEHyM=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.libplasma
    kdePackages.plasma-activities
    kdePackages.plasma-workspace
    kdePackages.kwin
    kdePackages.kcoreaddons
    kdePackages.kconfig
    kdePackages.kpackage
    kdePackages.kdeclarative
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=$out/share/plasma/plasmoids/org.dhruv8sh.kara"
    "-DKDE_INSTALL_USE_QT_SYS_PATHS=OFF"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "KDE Plasma Applet for use as a desktop/workspace pager";
    homepage = "https://github.com/dhruv8sh/kara";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    inherit (kdePackages.kwindowsystem.meta) platforms;
  };
})
