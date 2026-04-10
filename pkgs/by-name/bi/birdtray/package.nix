{
  stdenv,
  lib,
  fetchFromGitHub,

  cmake,
  pkg-config,
  libsForQt5,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "birdtray";
  version = "1.11.4";

  src = fetchFromGitHub {
    owner = "gyunaev";
    repo = "birdtray";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rj8tPzZzgW0hXmq8c1LiunIX1tO/tGAaqDGJgCQda5M=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];
  buildInputs = with libsForQt5; [
    qtbase
    qttools
    qtx11extras
  ];

  cmakeFlags = [
    # CMake 4 dropped support of versions lower than 3.5,
    # versions lower than 3.10 are deprecated.
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.10")
  ];

  # Wayland support is broken.
  # https://github.com/gyunaev/birdtray/issues/113#issuecomment-621742315
  qtWrapperArgs = [ "--set QT_QPA_PLATFORM xcb" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Mail system tray notification icon for Thunderbird";
    mainProgram = "birdtray";
    homepage = "https://github.com/gyunaev/birdtray";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ Flakebi ];
    platforms = lib.platforms.linux;
  };
})
