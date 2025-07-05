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
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "holo-routing";
    repo = "holo-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f34M3U7pitWuH1UQa4uJ/scIOAZiUtDXijOk8wZEm+c=";
  };

  cargoHash = "sha256-s2em9v4SRQdC0aCD4ZXyhNNYnVKkg9XFzxkOlEFHmL0=";
  passthru.updateScript = nix-update-script { };

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
