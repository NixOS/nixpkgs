{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "mpls";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "mhersson";
    repo = "mpls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mhQuycz+8UfZwsc2/gRuK6X26PxedcqlFyUM0IxqQJs=";
  };

  vendorHash = "sha256-w0YBeIaARC16BFp4uxJO8X8b1ozTbWFNUg7VQQa5iFw=";

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
