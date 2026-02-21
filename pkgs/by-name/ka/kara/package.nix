{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
  kdePackages,
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

  nativeBuildInputs = with pkgs; [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = with pkgs.kdePackages; [
    libplasma
    plasma-activities
    plasma-workspace
    kwin
    kcoreaddons
    kconfig
    kpackage
    kdeclarative
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=$out/share/plasma/plasmoids/org.dhruv8sh.kara"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DKDE_INSTALL_USE_QT_SYS_PATHS=OFF"
  ];

  installPhase = ''
    runHook preInstall
    cmake --install .
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "KDE Plasma Applet for use as a desktop/workspace pager";
    homepage = "https://github.com/dhruv8sh/kara";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    inherit (kdePackages.kwindowsystem.meta) platforms;
  };
})
