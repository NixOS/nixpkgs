{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-machete";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "bnjbvr";
    repo = "cargo-machete";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vC7Oj42GU7YlNtP+TUp+4LH2gxGk55RZ5cOLRaiEQ3w=";
  };

  cargoHash = "sha256-cmOMWJOSJxhjXVdwVdDnTORJRSZcQ8kdDUTJaIy8dbk=";

  # tests require internet access
  doCheck = false;

  meta = {
    description = "Cargo tool that detects unused dependencies in Rust projects";
    mainProgram = "cargo-machete";
    homepage = "https://github.com/bnjbvr/cargo-machete";
    changelog = "https://github.com/bnjbvr/cargo-machete/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
      chrjabs
    ];
  };
})
