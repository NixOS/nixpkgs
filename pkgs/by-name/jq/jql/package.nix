{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jql";
  version = "8.0.10";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = "jql";
    tag = "jql-v${finalAttrs.version}";
    hash = "sha256-QKdLKib9cz5TjU3+tKaB+1jD9H7bYXidzruldTO6iuw=";
  };

  cargoHash = "sha256-krhy+CLoQyXeYyLHuNYVleSPtEAFKrdf24zDBCGID2Q=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
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
