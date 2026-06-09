{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "cargo-feature-combinations";
  version = "0.0.53";

  src = fetchFromGitHub {
    owner = "romnn";
    repo = "cargo-feature-combinations";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t6WSqE3h62liesjH8UAcTeY/X61gQt+TO0eYmxjBtKc=";
  };

  cargoHash = "sha256-e4w98y3t+b1PZsbGuygzwNQIBRTUviEJke6MS0b/uMA=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cargo plugin to run commands against all combinations of features";
    homepage = "https://github.com/romnn/cargo-feature-combinations";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
      pinage404
    ];
    mainProgram = "cargo-feature-combinations";
  };
})
