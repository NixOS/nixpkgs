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
  version = "1.2.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "communique";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lQN6LViO3Ta6eCbU6j76OFN95R6A0hP3Pfc38KrHDng=";
  };

  cargoHash = "sha256-RJzjpDhxpi7Zmzw9kl48yq6//zTYOeJ+SrgAfqq/tl4=";

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
