{
  buildGoModule,
  lib,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "pyroscope";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "pyroscope";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7bY3qmN05m/OxFyDxdwlxsvYrwzhdbkX0XhGqOzCZSA=";
  };

  vendorHash = "sha256-UGWfrnpTgzR09T5jDL24d/Bs8+HBWi4g1YzZyy7ULWY=";
  proxyVendor = true;

  subPackages = [
    "cmd/pyroscope"
    "cmd/profilecli"
  ];

  ldflags = [
    "-X=github.com/grafana/pyroscope/v2/pkg/util/build.Branch=${finalAttrs.src.rev}"
    "-X=github.com/grafana/pyroscope/v2/pkg/util/build.Version=${finalAttrs.version}"
    "-X=github.com/grafana/pyroscope/v2/pkg/util/build.Revision=${finalAttrs.src.rev}"
    "-X=github.com/grafana/pyroscope/v2/pkg/util/build.BuildDate=1970-01-01T00:00:00Z"
  ];

  # We're overriding the version in 'ldFlags', so we should check that the
  # derivation 'version' string is found in 'pyroscope --version'.
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Continuous profiling platform; debug performance issues down to a single line of code";
    homepage = "https://github.com/grafana/pyroscope";
    changelog = "https://github.com/grafana/pyroscope/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      jkachmar
      lf-
    ];
    mainProgram = "pyroscope";
  };
})
