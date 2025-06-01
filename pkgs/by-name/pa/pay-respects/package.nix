{
  lib,
  fetchFromGitea,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pay-respects";
  version = "0.7.6";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "iff";
    repo = "pay-respects";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+50MKpZgJqjuUvJeFFv8fMILkJ3cOAN7R7kmlR+98II=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-TJP+GPkXwPvnBwiF0SCkn8NGz/xyrYjbUZKCbUUSqHQ=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Terminal command correction, alternative to thefuck, written in Rust";
    homepage = "https://codeberg.org/iff/pay-respects";
    changelog = "https://codeberg.org/iff/pay-respects/src/tag/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      sigmasquadron
      bloxx12
      ALameLlama
    ];
    mainProgram = "pay-respects";
  };
})
