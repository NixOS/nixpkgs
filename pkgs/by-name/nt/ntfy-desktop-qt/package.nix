{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  curl,
  nlohmann_json,
  kdePackages,
  emojicpp,
}:

stdenv.mkDerivation (finalAttrs: {
  # There are several projects called Ntfy Desktop
  # https://docs.ntfy.sh/integrations/#clis-guis
  # So disambiguate this one as using the Qt toolkit.
  # At the time of writing, the other options are GTK or Electron.
  pname = "ntfy-desktop-qt";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "emmaexe";
    repo = "ntfyDesktop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DUOoMAKvnKtM6Y8rW84mqcKaqc2OzO+H6YHaFO3bf4Q=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    curl
    emojicpp
    nlohmann_json
    kdePackages.kcoreaddons
    kdePackages.ki18n
    kdePackages.knotifications
    kdePackages.kxmlgui
    kdePackages.qtbase
  ];

  cmakeFlags = [
    # Avoids use of CPM, instead using our provided packages for emojicpp
    # and nlohmann_json
    # https://github.com/emmaexe/ntfyDesktop/blob/dee9bbe7663bd7a74f018089b2f57393662a7f09/CMakeLists.txt#L33-L34
    "-DND_BUILD_TYPE=Flatpak"
  ];

  strictDeps = true;

  meta = {
    description = "A desktop client for the ntfy.sh push notification system, built with the Qt framework";
    homepage = "https://github.com/emmaexe/ntfyDesktop";
    changelog = "https://github.com/emmaexe/ntfyDesktop/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "ntfyDesktop";
    platforms = lib.platforms.linux;
  };
})
