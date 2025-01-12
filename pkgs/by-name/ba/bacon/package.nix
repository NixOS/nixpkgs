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
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "bacon";
    rev = "refs/tags/v${version}";
    hash = "sha256-WbTxy8ijXez1x2G7NGGVMcyjgE7J7MDsGgGRpb4jKXQ=";
  };

  cargoHash = "sha256-rlWNrkzUDs3rbQ5ZV4fKU/EKEy4fVbxEP0+wNwXi7Ag=";

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
