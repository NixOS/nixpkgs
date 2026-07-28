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
  version = "1.2.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "communique";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F7m6PxPOuQlZFIVYBUl650JsaZVJJmC1c+6jMgmGgc8=";
  };

  cargoHash = "sha256-KyGbkVNi2rHTJfIeeq6nVFDhkWmaKh/IZ6xiVxPaXWQ=";

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
