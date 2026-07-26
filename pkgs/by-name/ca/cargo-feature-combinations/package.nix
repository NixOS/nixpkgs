{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "cargo-feature-combinations";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "romnn";
    repo = "cargo-feature-combinations";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0aPe0YmEpLHt3aZHDuNlov/TiRbLLpR7TLt0ULkjsVU=";
  };

  cargoHash = "sha256-r09otRStFli5Bx0pfDOMu1LGDonDyCVGPEdY/KnjkmY=";

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
