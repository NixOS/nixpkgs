{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "giff";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "bahdotsh";
    repo = "giff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oBZp0+tAYuAcj5vNXs2phW85Y+67WnH2CJiZ7cNpWpE=";
  };

  cargoHash = "sha256-IjXdWp5LdxIxfj2NL1EdxGh29L8Q/ExqX8yNHFStT1M=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal-based Git diff viewer with interactive rebase capabilities";
    homepage = "https://github.com/bahdotsh/giff";
    changelog = "https://github.com/bahdotsh/giff/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "giff";
  };
})
