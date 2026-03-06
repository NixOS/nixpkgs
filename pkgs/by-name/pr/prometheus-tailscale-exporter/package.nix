{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "tailscale-exporter";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "adinhodovic";
    repo = "tailscale-exporter";
    tag = finalAttrs.version;
    hash = "sha256-zZxKTEm23iXv4qYwx6gBtBuz5pduuIXLwMX0ZrrYxZs=";
  };

  vendorHash = "sha256-WHtmis8r62th90BrM+f63yuyRkW4bVT/vPDfcIJ3Fg8=";

  subPackages = [
    "cmd/tailscale-exporter"
    "collector"
  ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru.tests = {
    inherit (nixosTests.prometheus-exporters) tailscale;
  };

  meta = {
    description = "Tailscale Tailnet metric exporter for Prometheus";
    homepage = "https://github.com/adinhodovic/tailscale-exporter";
    changelog = "https://github.com/adinhodovic/tailscale-exporter/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      squat
    ];
    mainProgram = "tailscale-exporter";
  };
})
