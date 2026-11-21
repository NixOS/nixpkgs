{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "chasquid";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "albertito";
    repo = "chasquid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bx3DQJptamUuZaQhTmjb0g4wuRUxLm8SvntELiBQhyM=";
  };

  vendorHash = "sha256-A/70Mfh0hFXRn2Xcjbs5K7jEcpm0ZQaVLOqTns7vN88=";

  ldflags = [ "-X main.version=v${finalAttrs.version}" ];

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    description = "SMTP (email) server with a focus on simplicity, security, and ease of operation";
    homepage = "https://blitiri.com.ar/p/chasquid/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    mainProgram = "chasquid";
    maintainers = with lib.maintainers; [
      ThinkChaos
    ];
  };
})
