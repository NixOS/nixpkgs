{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  cairo,
  hyprlang,
  librsvg,
  libzip,
  xcur2png,
  tomlplusplus,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hyprcursor";
  version = "0.1.13";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprcursor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lIqabfBY7z/OANxHoPeIrDJrFyYy9jAM4GQLzZ2feCM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    cairo
    hyprlang
    librsvg
    libzip
    xcur2png
    tomlplusplus
  ];

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/hyprwm/hyprcursor";
    description = "Hyprland cursor format, library and utilities";
    changelog = "https://github.com/hyprwm/hyprcursor/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      iynaix
    ];
    teams = [ lib.teams.hyprland ];
    mainProgram = "hyprcursor-util";
    platforms = lib.platforms.linux;
  };
})
