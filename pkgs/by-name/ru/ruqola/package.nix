{
  stdenv,
  lib,
  fetchFromGitLab,
  cmake,
  extra-cmake-modules,
  kdePackages,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "ruqola";
  version = "2.5.0";
  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "network";
    repo = "ruqola";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gcdu/+JTutY7gvokHNVbWH5D82HhtLXkL6PLZN81ano=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
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
    kdePackages.qtbase
    kdePackages.qtkeychain
    kdePackages.qtmultimedia
    kdePackages.qtnetworkauth
    kdePackages.qtwebsockets
    kdePackages.sonnet
    kdePackages.syntax-highlighting
    kdePackages.wrapQtAppsHook
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
