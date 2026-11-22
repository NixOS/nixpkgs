{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "json-sort";
  version = "1.1.6";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "drupol";
    repo = "json-sort";
    tag = finalAttrs.version;
    hash = "sha256-NG3mrJRlW79Qz1/KkPrugx6Set5fXLLD3KjNrHkUjes=";
  };

  cargoHash = "sha256-0rW+wCA2LdLGlXnHaRIzQ4WK25m4rl39HV46mjfNws8=";

  dontUseCargoParallelTests = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line tool to sort JSON object keys in-place, preserving formatting and comments";
    homepage = "https://github.com/drupol/json-sort";
    license = lib.licenses.eupl12;
    mainProgram = "json-sort";
    maintainers = with lib.maintainers; [ drupol ];
    platforms = lib.platforms.all;
  };
})
