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
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "bacon";
    rev = "refs/tags/v${version}";
    hash = "sha256-Zo89XPaZncsKhePCQgcRY3lfOxBx4NWIZi+r37L1SbE=";
  };

  cargoHash = "sha256-EV55vzkBXvTJ3nw76mZNn96eOpn06v3+NdQsKYPybHc=";

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
    maintainers = with lib.maintainers; [ FlorianFranzen ];
  };
}
