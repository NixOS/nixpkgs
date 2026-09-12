{
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  lib,
}:
buildGoModule (finalAttrs: {
  pname = "aperture-cli";
  version = "0.0.8";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "aperture-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s+slAWcv6IJtfCJK8wORGsl7X0KoVXnxajYSD/AvbcI=";
  };

  vendorHash = "sha256-LXkf5l52+7JflU39MY4aNwiLa9rYaB4G1mPTRhm+l/8=";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/tailscale/aperture-cli";
    changelog = "https://github.com/tailscale/aperture-cli/releases/tag/${finalAttrs.src.tag}";
    description = "An agentic coding launcher for Tailscale Aperture";
    maintainers = with lib.maintainers; [ pascalj ];
    license = lib.licenses.bsd3;
    mainProgram = "aperture";
  };
})
