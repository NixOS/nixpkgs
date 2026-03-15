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
  version = "0.5.0-unstable-2026-01-16";

  src = fetchFromGitHub {
    owner = "holo-routing";
    repo = "holo-cli";
    rev = "4e76a41f00ff02dd647b3970377ef5f34fce70f4";
    hash = "sha256-VqSYNhd/A/9N2L9p0h9uV8V+BysHr4IkGwdwYyjw7bw=";
  };

  cargoHash = "sha256-7/OtT2TdLhFVZeuQOg6xQJFnGJNz/G9mna8vIeh86/k=";
  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  # Use rust nightly features
  env.RUSTC_BOOTSTRAP = 1;

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
