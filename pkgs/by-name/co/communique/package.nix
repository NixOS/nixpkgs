{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cacert,
  gitMinimal,
  ripgrep,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "communique";
  version = "1.3.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "communique";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bT3OiP3hYWNY0iXnfxg8Q6ndQBbcqgyLL2TVgOKP5gQ=";
  };

  cargoHash = "sha256-hg6r7kmyeFONeVndCoRZB9JzYrAX8QUKiZpSMbSGxoA=";

  nativeCheckInputs = [
    cacert
    gitMinimal
    ripgrep
  ];

  __darwinAllowLocalNetworking = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Editorialized release notes powered by AI";
    homepage = "https://github.com/jdx/communique";
    changelog = "https://github.com/jdx/communique/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Br1ght0ne ];
    mainProgram = "communique";
  };
})
