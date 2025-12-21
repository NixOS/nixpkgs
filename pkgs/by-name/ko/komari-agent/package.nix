{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "komari-agent";
  version = "1.1.40";

  src = fetchFromGitHub {
    owner = "komari-monitor";
    repo = "komari-agent";
    tag = "${finalAttrs.version}";
    hash = "sha256-aWCsaiYkpj0D9hr7V3pxSk14pMD2E117vwemt9Ckqv0=";
  };

  vendorHash = "sha256-5RL/dDR/Or9GRCPVQmUYKTV82q7xuN2Mqc4/86WmbqY=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/komari-monitor/komari-agent/update.CurrentVersion=${finalAttrs.version}"
  ];

  # tests require network access
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/komari-monitor/komari-agent";
    description = "Lightweight server probe for simple, efficient monitoring";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mlyxshi
    ];
    mainProgram = "komari-agent";
  };
})
