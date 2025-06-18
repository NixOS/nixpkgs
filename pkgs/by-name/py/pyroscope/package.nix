{
  buildGoModule,
  lib,
  fetchFromGitHub,
  nix-update-script,
  ...
}:

buildGoModule (finalAttrs: {
  pname = "pyroscope";
  version = "1.13.4";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "pyroscope";
    rev = "v1.13.4";
    hash = "sha256-nyb91BO4zzJl3AG/ojBO+q7WiicZYmOtztW6FTlQHMM=";
  };

  vendorHash = "sha256-GZMoXsoE3pL0T3tkWY7i1f9sGy5uVDqeurCvBteqV9A=";
  proxyVendor = true;

  subPackages = [
    "cmd/pyroscope"
    "cmd/profilecli"
  ];

  ldflags = [
    "-X=github.com/grafana/pyroscope/pkg/util/build.Branch=${finalAttrs.src.rev}"
    "-X=github.com/grafana/pyroscope/pkg/util/build.Version=${finalAttrs.version}"
    "-X=github.com/grafana/pyroscope/pkg/util/build.Revision=${finalAttrs.src.rev}"
    "-X=github.com/grafana/pyroscope/pkg/util/build.BuildDate=1970-01-01T00:00:00Z"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Continuous Profiling Platform. Debug performance issues down to a single line of code";
    homepage = "https://github.com/grafana/pyroscope";
    changelog = "https://github.com/grafana/pyroscope/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.teams.mercury ];
    mainProgram = "pyroscope";
  };
})
