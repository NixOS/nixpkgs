{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "tailscale-exporter";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "adinhodovic";
    repo = "tailscale-exporter";
    tag = finalAttrs.version;
    hash = "sha256-Ly+c60lNxsxugVQRJYPeP1BSKo6nHPGwP5ALg7/utWw=";
  };

  vendorHash = "sha256-y8O3a498/5Ca3KzBrgZaGHgTukuwet0rujlvEZbG6yo=";

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
