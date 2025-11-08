{
  lib,
  fetchFromGitea,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pay-respects";
  version = "0.7.9";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "iff";
    repo = "pay-respects";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qKej29kM0Kq5RRHo+lu9cGeTjnjUvpmIqSxq5yHuCKc=";
  };

  cargoHash = "sha256-2MEbUBTZ/zsPLhHTnQCrWQManqUQ3V3xta5NT9gu38A=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Terminal command correction, alternative to thefuck, written in Rust";
    homepage = "https://codeberg.org/iff/pay-respects";
    changelog = "https://codeberg.org/iff/pay-respects/src/tag/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      sigmasquadron
      faukah
      ALameLlama
    ];
    mainProgram = "pay-respects";
  };
})
