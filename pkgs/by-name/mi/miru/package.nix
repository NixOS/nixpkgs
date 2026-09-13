{
  lib,
  stdenv,
  fetchFromCodeberg,
  cmake,
  ninja,
  pkg-config,
  wayland-scanner,
  wayland,
  wayland-protocols,
  libffi,
  libGL,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {

  pname = "miru";
  version = "0.8.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromCodeberg {
    owner = "Vaishnav-Sabari-Girish";
    repo = "miru";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pv4wFAUo7wwMPxTpjeXvxbD5fLOoX8606UKwmMgKYAk=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    wayland-protocols
    libffi
    libGL
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wayland-native screen magnifier and cursor spotlight tool";
    homepage = "https://codeberg.org/Vaishnav-Sabari-Girish/miru";
    changelog = "https://codeberg.org/Vaishnav-Sabari-Girish/miru/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yvnth ];
    platforms = lib.platforms.linux;
    mainProgram = "miru-daemon";
  };
})
