{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  protobuf,
  pcre2,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "holo-cli";
  version = "0.5.0-unstable-2025-08-09";

  src = fetchFromGitHub {
    owner = "holo-routing";
    repo = "holo-cli";
    rev = "52844aab4831655b1b3efc44206af9a5571b285a";
    hash = "sha256-5m0k60FXgSmDgLAAmBuzYjnA6V4GXvl8bIt2wAjCpcM=";
  };

  cargoHash = "sha256-bsoxWjOMzRRtFGEaaqK0/adhGpDcejCIY0Pzw1HjQ5U=";
  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  # Use rust nightly features
  RUSTC_BOOTSTRAP = 1;

  nativeBuildInputs = [
    cmake
    pkg-config
    protobuf
  ];
  buildInputs = [
    pcre2
  ];

  meta = {
    description = "Holo` Command Line Interface";
    homepage = "https://github.com/holo-routing/holo-cli";
    teams = with lib.teams; [ ngi ];
    maintainers = with lib.maintainers; [ themadbit ];
    license = lib.licenses.mit;
    mainProgram = "holo-cli";
    platforms = lib.platforms.all;
  };
})
