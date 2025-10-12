{
  lib,
  buildGoModule,
  fetchFromGitHub,
  osv-detector,
  testers,
}:

buildGoModule rec {
  pname = "osv-detector";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "G-Rath";
    repo = "osv-detector";
    rev = "v${version}";
    hash = "sha256-2Ugnkexuoo0/Q3xB5BPbsBoBgw9Kd0q1zIQNr1Hpfjs=";
  };

  vendorHash = "sha256-BbYPyOwHhYDZx33yr3V/83trXl+QvVA69PKI6uMp0lc=";

  ldflags = [
    "-w"
    "-s"
    "-X main.version=${version}"
  ];

  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = osv-detector;
    command = "osv-detector -version";
    version = "osv-detector ${version} (unknown, commit none)";
  };

  meta = {
    description = "Auditing tool for detecting vulnerabilities";
    mainProgram = "osv-detector";
    homepage = "https://github.com/G-Rath/osv-detector";
    changelog = "https://github.com/G-Rath/osv-detector/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
