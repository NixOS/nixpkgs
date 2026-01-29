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
  version = "0.5.0-unstable-2025-12-19";

  src = fetchFromGitHub {
    owner = "holo-routing";
    repo = "holo-cli";
    rev = "bf712cf345be9f861e371b86732a93cea45de52e";
    hash = "sha256-HHwxjsuhY0g2WWQBpaWPVNBhMlFu8H3ypDDcfWKdbGE=";
  };

  cargoHash = "sha256-7/OtT2TdLhFVZeuQOg6xQJFnGJNz/G9mna8vIeh86/k=";
  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  # Use rust nightly features
  env.RUSTC_BOOTSTRAP = 1;

  nativeBuildInputs = [
    cmake
    pkg-config
    protobuf
    pcre2.dev
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
