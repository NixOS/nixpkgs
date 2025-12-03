{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "infat";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "philocalyst";
    repo = "infat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M0A9/rjw5aX4yfkEzkczLcvMpMuVTV5u1eyKhlM7nNk=";
  };

  cargoHash = "sha256-8WE9TiZX1QWenjEQF/uhzJ8Gqbggt8B9EZ+1tzWq72Q=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line tool to set default openers for file formats and url schemes on macOS";
    homepage = "https://github.com/philocalyst/infat";
    changelog = "https://github.com/philocalyst/infat/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      mirkolenz
    ];
    mainProgram = "infat";
  };
})
