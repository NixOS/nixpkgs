{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "air-formatter";
  version = "0.10.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "posit-dev";
    repo = "air";
    tag = finalAttrs.version;
    hash = "sha256-u0icSo6aW6tLgY57RPAoVte5Awn16FLIvZEeeYNr5fk=";
  };

  cargoHash = "sha256-51xkTVs6j7n0os5wHWxpFC/uLHm3tz+SiWUHsd+bNRw=";

  useNextest = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
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
