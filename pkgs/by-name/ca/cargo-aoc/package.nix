{
  lib,
  rustPlatform,
  fetchCrate,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-aoc";
  version = "0.3.8";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-5CjY91515GeLzmLJiGjfbBfIMPr32EA65X/rriKPWRY=";
  };

  cargoHash = "sha256-LhPsiO0Fnx9Tf+itaaVaO1XgqM00m+UQMlUJYY8isXY=";

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
}
