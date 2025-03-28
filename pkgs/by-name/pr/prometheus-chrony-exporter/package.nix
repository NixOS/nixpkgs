{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "prometheus-chrony-exporter";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "superq";
    repo = "chrony_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZXqCZZx0UG8050SYgVwD+wnTX0N41Bjv1dhdQmOHmR4=";
  };

  vendorHash = "sha256-3zL7BrCdMVnt7F1FiZ2eQnKVhmCeW3aYKKX9v01ms/k=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/superq/chrony_exporter/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/superq/chrony";
    description = "Prometheus exporter for the chrony NTP service";
    license = lib.licenses.asl20;
    mainProgram = "chrony_exporter";
    maintainers = with lib.maintainers; [ paepcke ];
  };
})
