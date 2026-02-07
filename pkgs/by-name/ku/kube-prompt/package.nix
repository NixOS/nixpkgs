{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "kube-prompt";
  version = "1.0.11";

  src = fetchFromGitHub {
    owner = "c-bata";
    repo = "kube-prompt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9OWsITbC7YO51QzsRwDWvojU54DiuGJhkSGwmesEj9w=";
  };

  vendorHash = "sha256-wou5inOX8vadEBCIBccwSRjtzf0GH1abwNdUu4JBvyM=";

  ldflags = [
    "-s"
    "-w"
  ];

  # kube-prompt doesn't support --version and requires kubernetes config
  doInstallCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Interactive kubernetes client featuring auto-complete";
    mainProgram = "kube-prompt";
    license = lib.licenses.mit;
    homepage = "https://github.com/c-bata/kube-prompt";
    changelog = "https://github.com/c-bata/kube-prompt/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ vdemeester ];
  };
})
