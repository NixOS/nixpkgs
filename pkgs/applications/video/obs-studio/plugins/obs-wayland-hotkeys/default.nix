{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  obs-studio,
  pkg-config,
  qtbase,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttr: {
  pname = "obs-wayland-hotkeys";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "leia-uwu";
    repo = "obs-wayland-hotkeys";
    tag = "v${finalAttr.version}";
    hash = "sha256-m/AW2glyxJLPWcptZYbZ9Befm4gNmD1V3JDC8hjKtkA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    obs-studio
    qtbase
  ];

  dontWrapQtApps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "OBS Studio plugin to integrate OBS hotkeys with the Wayland global shortcuts portal";
    homepage = "https://github.com/leia-uwu/obs-wayland-hotkeys";
    maintainers = with lib.maintainers; [ terrorw0lf ];
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
})
