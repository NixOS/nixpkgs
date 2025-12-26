{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jql";
  version = "8.0.9";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = "jql";
    tag = "jql-v${finalAttrs.version}";
    hash = "sha256-1gkKOOR2mIUKrbVb1BlFxVuskL6y7s6mrI99xTfjjTI=";
  };

  cargoHash = "sha256-7pSvHZqvPW9SXwU0AtQHIjgHQCSKPzrBhNxLY5ZAcMw=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    changelog = "https://github.com/yamafaktory/jql/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      akshgpt7
    ];
    mainProgram = "jql";
  };
})
