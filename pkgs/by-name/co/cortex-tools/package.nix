{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitUpdater,
  versionCheckHook,
  installShellFiles,
  stdenv,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "cortex-tools";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "cortex-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+GWUC+lnCn5Nw2WytSvW/UsIMmMelCCsnKdBCHuue24=";
  };

  vendorHash = null;

  subPackages = [
    "cmd/benchtool"
    "cmd/cortextool"
    "cmd/e2ealerting"
    "cmd/logtool"
  ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-X github.com/grafana/cortex-tools/pkg/version.Version=${finalAttrs.src.tag}"
    "-s"
    "-w"
  ];

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd cortextool \
      --bash <($out/bin/cortextool --completion-script-bash) \
      --zsh <($out/bin/cortextool --completion-script-zsh)

    $out/bin/cortextool --help-man > cortextool.1
    installManPage cortextool.1
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "version";

  meta = {
    changelog = "https://github.com/grafana/cortex-tools/releases/tag/${finalAttrs.src.tag}";
    description = "Tools used for interacting with Cortex, a Prometheus-compatible server";
    longDescription = ''
      Tools used for interacting with Cortex, a horizontally scalable, highly available, multi-tenant, long term Prometheus server:

      - benchtool: A powerful YAML driven tool for benchmarking Cortex write and query API.
      - cortextool: Interacts with user-facing Cortex APIs and backend storage components.
      - logtool: Tool which parses Cortex query-frontend logs and formats them for easy analysis.
      - e2ealerting: Tool that helps measure how long an alert takes from scrape of sample to Alertmanager notification delivery.
    '';
    homepage = "https://github.com/grafana/cortex-tools";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.windows ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ videl ];
    mainProgram = "cortextool";
  };
})
