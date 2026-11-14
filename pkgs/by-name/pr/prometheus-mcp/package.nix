{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "prometheus-mcp";
  version = "0.18.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "prometheus-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-67pkE28hbORN+etTkon4u9HzWTKL0K1q0GNp8X2Oaqo=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-QAny2SDYHaUHgiUn0KNesDmwfwh5NWpUB3FtwsB2g/I=";

  ldflags = [
    "-s"
    "-X github.com/tjhop/prometheus-mcp-server/internal/version.Version=${finalAttrs.version}"
    "-X github.com/tjhop/prometheus-mcp-server/internal/version.BuildDate=unknown"
    "-X github.com/tjhop/prometheus-mcp-server/internal/version.Commit=unknown"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit (nixosTests.prometheus) mcp;
    };
  };

  meta = {
    description = "MCP server for LLMs to interact with Prometheus";
    homepage = "https://github.com/prometheus/prometheus-mcp";
    changelog = "https://github.com/prometheus/prometheus-mcp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      fpletz
      Frostman
      jpds
    ];
    mainProgram = "prometheus-mcp-server";
  };
})
