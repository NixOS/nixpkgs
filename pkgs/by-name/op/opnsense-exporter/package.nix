{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "opnsense-exporter";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "AthennaMind";
    repo = "opnsense-exporter";
    rev = "v${version}";
    hash = "sha256-r8Hagn8WbQxUaIjWfXSQ4VIjAtGxOwr+g6kalalf6oQ=";
  };

  vendorHash = null;

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  tags = [
    "osuergo"
    "netgo"
  ];

  meta = {
    description = "OPNsense Exporter for Prometheus";
    homepage = "https://github.com/AthennaMind/opnsense-exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ callumio ];
    mainProgram = "opnsense-exporter";
  };
}
