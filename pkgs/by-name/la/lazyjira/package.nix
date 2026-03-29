{
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  lib,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "lazyjira";
  version = "2.19.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "textfuel";
    repo = "lazyjira";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ejisbVjzTFD6MStJ5uZfEdLwoHKS2912vKdEyl1VoAM=";
  };

  vendorHash = "sha256-ZRN4dETJhTgBn2S3w0dMJ9itoCWt/afe8FtCABp0l7Q=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  nativeCheckInputs = [ gitMinimal ];

  # Tests start local HTTP servers
  __darwinAllowLocalNetworking = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lazygit but for Jira";
    longDescription = ''
      lazyjira is a keyboard-driven terminal UI for Jira Cloud and Jira
      Server or Data Center, inspired by lazygit.  It lets you browse
      issues, update statuses, read descriptions and more from the
      terminal.
    '';
    homepage = "https://github.com/textfuel/lazyjira";
    changelog = "https://github.com/textfuel/lazyjira/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "lazyjira";
  };
})
