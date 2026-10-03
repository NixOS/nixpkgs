{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "brief";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "git-pkgs";
    repo = "brief";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hmDtvHG51vK8s12Bh6hYkfEyLDauRUEEAIvE8n5XHuM=";
  };
  vendorHash = "sha256-9pxFAnvENcf1YJGrwrjO6ykknzCxXlc6P2UMsWxTjCA=";

  ldflags = [
    "-X github.com/git-pkgs/brief.Version=${finalAttrs.version}"
  ];

  __structuredAttrs = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool that detects a software project's toolchain, configuration, and conventions";
    homepage = "https://github.com/git-pkgs/brief";
    changelog = "https://github.com/git-pkgs/brief/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ junestepp ];
    mainProgram = "brief";
  };
})
