{
  stdenv,
  lib,
  fetchFromGitLab,
  cmake,
  extra-cmake-modules,
  kdePackages,
  qt6,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "ruqola";
  version = "2.5.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "network";
    repo = "ruqola";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gcdu/+JTutY7gvokHNVbWH5D82HhtLXkL6PLZN81ano=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.karchive
    kdePackages.kcodecs
    kdePackages.kcoreaddons
    kdePackages.kcrash
    kdePackages.ki18n
    kdePackages.kiconthemes
    kdePackages.kidletime
    kdePackages.kio
    kdePackages.knotifyconfig
    kdePackages.kstatusnotifieritem
    kdePackages.ktextaddons
    kdePackages.ktextwidgets
    kdePackages.kxmlgui
    kdePackages.plasma-activities
    kdePackages.prison
    kdePackages.purpose
    kdePackages.qtkeychain
    kdePackages.sonnet
    kdePackages.syntax-highlighting
    qt6.qtbase
    qt6.qtmultimedia
    qt6.qtnetworkauth
    qt6.qtwebsockets
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "KDE client for Rocket Chat";
    homepage = "https://invent.kde.org/network/ruqola";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ lykos153 ];
    mainProgram = "ruqola";
  };
})
