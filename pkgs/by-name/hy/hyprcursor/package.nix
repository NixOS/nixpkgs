{
  lib,
  gcc14Stdenv,
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
gcc14Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprcursor";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprcursor";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-LOTmvTIxmaWtXF8OP6b6oENSdG/quWxhsO3dJQACBUw=";
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
    maintainers = with lib.maintainers; [ iynaix ];
    mainProgram = "hyprcursor-util";
    platforms = lib.platforms.linux;
  };
})
