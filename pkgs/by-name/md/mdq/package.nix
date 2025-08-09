{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdq";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "yshavit";
    repo = "mdq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QGva+yuiNwez8z9j4SL8vpcHdUm8nxRFn+6WiZgdWjQ=";
  };

  cargoHash = "sha256-k+St07jA+F+c4md9OzFiDp9idie6zoNI65HEQ2JqynM=";

  passthru.updateScript = nix-update-script { };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Like jq but for Markdown: find specific elements in a md doc";
    homepage = "https://github.com/yshavit/mdq";
    changelog = "https://github.com/yshavit/mdq/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ DimitarNestorov ];
    mainProgram = "mdq";
  };
})
