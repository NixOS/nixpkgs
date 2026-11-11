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
  version = "0.3.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "dashboard-linter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vKdfjlDZokVOd3tUlhMMRd9VXOrI5wBmxo1sjKcElZY=";
  };

  vendorHash = "sha256-rWJqlsmGoCVhEbt0ersZP5RFaKcG0xq5jHy4Tm7SoU0=";

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
