{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "prometheus-solaredge-exporter";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "solaredge_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vo0WaiigwjSEA+wEUs8Wdko+UHq5OXXcVcfgna/QVHE=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/prometheus/common/version.BuildDate=1970-01-01T00:00:00Z"
    "-X github.com/prometheus/common/version.BuildUser=nix@nixpkgs"
    "-X github.com/prometheus/common/version.Branch=master"
    "-X github.com/prometheus/common/version.Revision=${finalAttrs.src.rev}"
    "-X github.com/prometheus/common/version.Version=${finalAttrs.version}"
  ];

  vendorHash = "sha256-ltCjuihbm0/bj2SPkiITTHzYmcQsX12xvt+OpYROivU=";

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";
  versionCheckProgramArg = "--version";

  meta = {
    changelog = "https://github.com/paepckehh/solaredge_exporter/releases/tag/v${finalAttrs.version}";
    homepage = "https://paepcke.de/solaredge_exporter";
    description = "Prometheus exporter for solaredge solar inverter local tcp modbus interface";
    license = lib.licenses.mit;
    mainProgram = "solaredge_exporter";
    maintainers = with lib.maintainers; [ paepcke ];
  };
})
