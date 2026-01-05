{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "autocast";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "k9withabone";
    repo = "autocast";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F8RTXcBe3eqzwR48CcU1DpqRzhMBztGIXJrJsQdjgks=";
  };

  cargoHash = "sha256-VeOFYaN5HJHTfMjUF4IBT54mxPjfdnZNB8ptUQRfAYk=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Automate terminal demos";
    homepage = "https://github.com/k9withabone/autocast";
    changelog = "https://github.com/k9withabone/autocast/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "autocast";
  };
})
