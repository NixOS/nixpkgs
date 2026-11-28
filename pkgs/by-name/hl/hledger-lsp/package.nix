{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGo127Module (finalAttrs: {
  pname = "hledger-lsp";
  version = "0.3.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "juev";
    repo = "hledger-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J9EUA4aWp8lXtMM+l/ltOAIaLwci/dS4+sELa4okGpQ=";
  };

  vendorHash = "sha256-imF6wCMC+5J94TQjZU0SXOwlw5SR/EB60GeYVS3O/iA=";

  subPackages = [
    "cmd/hledger-lsp"
    "cmd/hledger-fmt"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language server and formatter for hledger journal files";
    homepage = "https://github.com/juev/hledger-lsp";
    changelog = "https://github.com/juev/hledger-lsp/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sumnerevans ];
    mainProgram = "hledger-lsp";
  };
})
