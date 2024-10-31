{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  darwin,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "bacon";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "bacon";
    rev = "refs/tags/v${version}";
    hash = "sha256-fSlakjZbY8jrFkCqVxPr3UKwf1Oq4yPhLmVbzsksSeg=";
  };

  cargoHash = "sha256-WT0uXmchhapss3AU4+e2wA3nBVjzikfRNRyAvQnpJfY=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
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
