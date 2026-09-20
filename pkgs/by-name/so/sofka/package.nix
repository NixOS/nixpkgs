{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sofka";
  version = "0.25.3";

  src = fetchFromGitHub {
    owner = "nklmilojevic";
    repo = "sofka";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e/+cdD8B+yE4tQzk73LdUbAX9ULKn4XJyoBUYb3fVOs=";
  };

  cargoHash = "sha256-YNMVlZ50D5thqJE5658h34PYQjxqcOvnAIAB2dbpArg=";

  __structuredAttrs = true;

  # The test suite builds a rustls-backed kube::Client, which needs native
  # root CA certificates that are unavailable in the build sandbox.
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Kubernetes TUI, reimagined in Rust";
    homepage = "https://github.com/nklmilojevic/sofka";
    changelog = "https://github.com/nklmilojevic/sofka/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "sofka";
    maintainers = with lib.maintainers; [ jakuzure ];
    platforms = lib.platforms.unix;
  };
})
