{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
  withLocaleSupport ? true,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "biff";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = "biff";
    tag = finalAttrs.version;
    hash = "sha256-7KkzmaWbUHrLUd7lADJLPLSeE/RYJvVAEL+FcE5KIhY=";
  };

  buildFeatures = lib.optional withLocaleSupport "locale";

  cargoHash = "sha256-pGY1KDcsBz5J/mf4c8zDVbivgzfimSy8ruNoa+Pn9p8=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line tool for datetime arithmetic, parsing, formatting and more";
    homepage = "https://github.com/BurntSushi/biff";
    changelog = "https://github.com/BurntSushi/biff/blob/${finalAttrs.version}/CHANGELOG.md";
    license = [
      lib.licenses.mit
      lib.licenses.unlicense
    ];
    maintainers = [ lib.maintainers.kpbaks ];
    mainProgram = "biff";
    platforms = lib.platforms.all;
  };
})
