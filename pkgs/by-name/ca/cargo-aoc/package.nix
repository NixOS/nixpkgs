{
  lib,
  rustPlatform,
  fetchCrate,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-aoc";
  version = "0.3.8";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-5CjY91515GeLzmLJiGjfbBfIMPr32EA65X/rriKPWRY=";
  };

  cargoHash = "sha256-q0kpo6DNR+8129+vJSLoOC/bUYjlfaB77YTht6+kT00=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple CLI tool that aims to be a helper for Advent of Code";
    homepage = "https://github.com/gobanos/cargo-aoc";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "cargo-aoc";
  };
})
