{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "air-formatter";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "posit-dev";
    repo = "air";
    tag = finalAttrs.version;
    hash = "sha256-LNU//dQico54GhZdehynEuukfGuU8rQvfFO4zvRsZL0=";
  };

  cargoHash = "sha256-9HRDUTYzKLYuh9KCcnvPXB6gDKcht79TOZZ3ze9+gbg=";

  useNextest = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/air";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  cargoBuildFlags = [ "-p air" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Extremely fast R code formatter";
    homepage = "https://posit-dev.github.io/air";
    changelog = "https://github.com/posit-dev/air/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.kupac ];
    mainProgram = "air";
  };
})
