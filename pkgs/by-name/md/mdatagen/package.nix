{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "mdatagen";
  # Also update `pkgs/tools/misc/opentelemetry-collector/releases.nix`
  # whenever that version changes.
  version = "0.135.0";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-collector";
    rev = "cmd/mdatagen/v${version}";
    hash = "sha256-ntRWAYbVbtZBqewXx4+YCZspRr+wSE2iGgmH8PEfj5o=";
  };

  sourceRoot = "${src.name}/cmd/mdatagen";
  vendorHash = "sha256-YQNvvE9p4LVarU9ybKNcxQz20+K/Fur0V+meCtd7Xu8=";

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
    "-X go.opentelemetry.io/collector/cmd/mdatagen/internal.version=${version}"
  ];

  # Some tests download new dependencies for a modified go.mod. Nix doesn't allow network access so skipping.
  checkFlags = [
    "-skip TestValidateMetricDuplicates"
  ];

  meta = {
    description = "OpenTelemetry Collector";
    homepage = "https://github.com/open-telemetry/opentelemetry-collector.git";
    changelog = "https://github.com/open-telemetry/opentelemetry-collector/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aos ];
    mainProgram = "mdatagen";
  };
}
