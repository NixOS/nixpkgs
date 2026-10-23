{
  stdenv,
  lib,
  fetchFromGitLab,
  cmake,
  kdePackages,
  qt6,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ruqola";
  version = "2.9.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "network";
    repo = "ruqola";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AW+zt7rNEAtipMnpb0W/517Udbb9m8RecpQ7p/9alo0=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
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
    qt6.qtspeech
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
