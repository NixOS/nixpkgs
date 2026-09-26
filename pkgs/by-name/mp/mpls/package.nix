{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "mpls";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "mhersson";
    repo = "mpls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-26WRMprKyuxyyW8rBwjTPbsU9XCqUle6NBIoubXuzCM=";
  };

  vendorHash = "sha256-Yo6uD0hRwBEPtYDqYs4ZB5NhICwZpkO3VdCl8B/+7qQ=";

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
