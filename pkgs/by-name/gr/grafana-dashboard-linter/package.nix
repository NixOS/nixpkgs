{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "grafana-dashboard-linter";
  version = "0.5.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "dashboard-linter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Bh/fbhfrZ0sLkOLXuywFxd5yLPMoFGiHaGw3tH2UgaQ=";
  };

  vendorHash = "sha256-BBICQVSZuCQ4O5m0rv0Vtka3vSJpzsHnghErhDTrZB4=";

  ldflags = [ "-s" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd dashboard-linter \
      --bash <($out/bin/dashboard-linter completion bash) \
      --fish <($out/bin/dashboard-linter completion fish) \
      --zsh <($out/bin/dashboard-linter completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Linter for Grafana dashboards";
    homepage = "https://github.com/grafana/dashboard-linter";
    changelog = "https://github.com/grafana/dashboard-linter/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kranzes ];
    mainProgram = "dashboard-linter";
  };
})
