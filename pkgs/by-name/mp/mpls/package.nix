{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "mpls";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "mhersson";
    repo = "mpls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a33XbUw6H2EKfGZnpV6L00iab6AoXqPiNTMw/OaouHs=";
  };

  vendorHash = "sha256-pi7KBA/313cG0AYWM/mUDng2M9L2tMLkonY4LI5XiW0=";

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
