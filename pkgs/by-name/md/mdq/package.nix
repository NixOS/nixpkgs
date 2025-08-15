{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdq";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "yshavit";
    repo = "mdq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LwvbOxKkMSMb+QfkO7h1WOeBzztmHeTcowVkdEKEWP8=";
  };

  cargoHash = "sha256-IUPkbVrQL3UYrONuPwH7DBzFo/qZ+ircU4vMqwPOg/M=";

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
