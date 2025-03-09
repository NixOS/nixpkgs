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
  fetchpatch,
}:
gcc14Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprcursor";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprcursor";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-NqihN/x8T4+wumSP1orwCCdEmD2xWgLR5QzfY+kAtuU=";
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

  patches = [
    # NOTE: remove after next release
    (fetchpatch {
      name = "001-add-fstream-include";
      url = "https://github.com/hyprwm/hyprcursor/commit/c18572a92eb39e4921b4f4c2bca8521b6f701b58.patch";
      hash = "sha256-iHRRd/18xEAgvJgmZeSzMp53s+zdIpuaP/sayRfcft4=";
    })
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
