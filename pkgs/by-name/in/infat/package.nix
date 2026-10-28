{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "infat";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "philocalyst";
    repo = "infat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/lZqI6E6mGQLtc3bmDH1NhnmVYa4sLjMJaYga33vLmI=";
  };

  cargoHash = "sha256-XPwhwJNHou5fJZ94RpbOlWUPQjw45PNmYCRzmukrFYo=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  # The v3.1.2 tag ships infat-cli/Cargo.toml with version = "3.1.1", so the
  # built binary reports "infat-cli 3.1.1" and versionCheckHook fails. Disable
  # the check until upstream aligns the crate version with the release tag.
  # https://github.com/philocalyst/infat/blob/v3.1.2/infat-cli/Cargo.toml
  doInstallCheck = false;

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
