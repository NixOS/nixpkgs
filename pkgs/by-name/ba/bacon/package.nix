{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "bacon";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "bacon";
    rev = "refs/tags/v${version}";
    hash = "sha256-pw+EfmpDvMCKSHOeHiv06x13/tRuf053Zcj8z0eWnPs=";
  };

  cargoHash = "sha256-W1bDZSUBjPmb/7bOnE+E5byA0clJZ+qGJ4XYASAjfeU=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Background rust code checker";
    mainProgram = "bacon";
    homepage = "https://github.com/Canop/bacon";
    changelog = "https://github.com/Canop/bacon/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      FlorianFranzen
      matthiasbeyer
    ];
  };
}
