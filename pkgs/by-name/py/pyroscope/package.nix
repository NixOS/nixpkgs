{
  stdenv,
  buildGoModule,
  lib,
  fetchFromGitHub,
  versionCheckHook,
  installShellFiles,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "pyroscope";
  version = "1.19.1";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "pyroscope";
    rev = "v${finalAttrs.version}";
    hash = "sha256-UPxGimkzXLFACqmAM1hNQIoNjN6OquVibwVmNvP00+s=";
  };

  vendorHash = "sha256-O8ZKIl5d2gvmtCqJOJJ5SU+qhNRyWj2kH0xHZzfLN5Y=";
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

  # We're overriding the version in 'ldFlags', so we should check that the
  # derivation 'version' string is found in 'pyroscope --version'.
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd pyroscope \
      --bash <($out/bin/pyroscope completion bash) \
      --fish <($out/bin/pyroscope completion fish) \
      --zsh <($out/bin/pyroscope completion zsh)
  '';

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
