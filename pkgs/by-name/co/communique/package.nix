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
  version = "1.3.5";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "communique";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qkrKyAlkqWU0nQmxRYr3HI670w9SfbEY0m/eX8gBrvk=";
  };

  cargoHash = "sha256-SW1AKnvzVLkiYnCoiEdZKfWw89y7VbFFRhoGxvIPGG8=";

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
