{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "pacproxy";
  version = "2.0.6";

  src = fetchFromGitHub {
    owner = "williambailey";
    repo = "pacproxy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GgNNWHiIWArNH6+OWOEM5U/HRgnX11qoGVNjZIt4j38=";
  };

  vendorHash = "sha256-I3wI7Z/Gcp7fdOYXkl98EBMwQEEdlHyrq2I1E3KMVME=";

  meta = {
    description = "No-frills local HTTP proxy server powered by a proxy auto-config (PAC) file";
    homepage = "https://github.com/williambailey/pacproxy";
    changelog = "https://github.com/williambailey/pacproxy/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ terlar ];
    mainProgram = "pacproxy";
  };
})
