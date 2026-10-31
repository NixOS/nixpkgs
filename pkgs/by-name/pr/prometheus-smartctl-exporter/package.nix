{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
  smartmontools,
}:

buildGoModule (finalAttrs: {
  pname = "smartctl_exporter";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "smartctl_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HwyVczHaXjc7e53mKr0TQ5JgGaFKiuRK7b6K+Z1kucw=";
  };

  vendorHash = "sha256-Grw8k8nSJYBWQCfSf9HSNjIuyk2UIUaRoFQYtnG8668=";

  postPatch = ''
    substituteInPlace main.go README.md \
      --replace-fail /usr/sbin/smartctl ${lib.getExe smartmontools}
  '';

  ldflags = [
    "-X github.com/prometheus/common/version.Version=${finalAttrs.version}"
  ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) smartctl; };

  meta = {
    changelog = "https://github.com/prometheus-community/smartctl_exporter/releases/tag/${finalAttrs.src.tag}";
    description = "Export smartctl statistics for Prometheus";
    mainProgram = "smartctl_exporter";
    homepage = "https://github.com/prometheus-community/smartctl_exporter";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      hexa
      Frostman
    ];
  };
})
