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
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "bacon";
    rev = "refs/tags/v${version}";
    hash = "sha256-L+LVD7ceKUQ+nVyepusrv9Zz4BSGjXucnimsf+abM2k=";
  };

  cargoHash = "sha256-NUCy3DZ1uV1iPanHGbK/TSY6oS3zSQxVpmnw7Aon+pw=";

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
