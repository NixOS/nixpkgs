{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "tailscale-exporter";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "adinhodovic";
    repo = "tailscale-exporter";
    tag = finalAttrs.version;
    hash = "sha256-kz5Z5BjojZQKpq3TzCW/1z7BwRjQLG7K5GAtQW561Do=";
  };

  vendorHash = "sha256-WtA94Ds52nee3ZfZWESC2o1Pz1rPQSTTTe7gOmOqk9g=";

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
