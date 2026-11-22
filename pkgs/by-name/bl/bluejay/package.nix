{
  lib,
  stdenv,
  fetchFromCodeberg,
  cmake,
  ninja,
  kdePackages,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bluejay";
  version = "1.0.3";

  src = fetchFromCodeberg {
    owner = "EbonJaeger";
    repo = "bluejay";
    tag = "v${finalAttrs.version}";
    hash = "sha256-18jpUaFeUIldtvnSuV8nCozO/KYog15AR+/3kby86hs=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.bluez-qt
    kdePackages.kcolorscheme
    kdePackages.kconfig
    kdePackages.kcoreaddons
    kdePackages.kdbusaddons
    kdePackages.ki18n
    kdePackages.kirigami
    kdePackages.kirigami-addons
    kdePackages.qtbase
    kdePackages.qtdeclarative
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "bluejay";
    description = "Bluetooth manager written in Qt";
    homepage = "https://codeberg.org/EbonJaeger/bluejay";
    changelog = "https://codeberg.org/EbonJaeger/bluejay/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
