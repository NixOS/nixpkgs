{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "mpls";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "mhersson";
    repo = "mpls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MMFwWHgdSkUgwx+XxBCIL4dElY1HIM5h2XNFTZBKNkQ=";
  };

  vendorHash = "sha256-fE6GFfrDS3k9BmsL2+UbefG/EQngI/WGRZA3U10VBP4=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mhersson/mpls/cmd.Version=${finalAttrs.version}"
    "-X github.com/mhersson/mpls/internal/mpls.Version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Live preview of markdown using Language Server Protocol";
    homepage = "https://github.com/mhersson/mpls";
    changelog = "https://github.com/mhersson/mpls/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jervw ];
    mainProgram = "mpls";
  };
})
