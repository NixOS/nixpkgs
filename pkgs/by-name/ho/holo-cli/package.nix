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
  version = "0.5.0-unstable-2025-08-29";

  src = fetchFromGitHub {
    owner = "holo-routing";
    repo = "holo-cli";
    rev = "31bca792c76e2ecb4d864a96cb20cc770135be74";
    hash = "sha256-XNVeuAAsSdU9CM/HL/3UkBSgxngPheKuwTMkzm+MQ4Q=";
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
