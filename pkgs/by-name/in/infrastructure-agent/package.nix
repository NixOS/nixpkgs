{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "infrastructure-agent";
  version = "1.62.0";

  src = fetchFromGitHub {
    owner = "newrelic";
    repo = "infrastructure-agent";
    rev = version;
    hash = "sha256-qwbYDPj47Tya1De+4hawgkz+StZ5seR+UNPc2vhl+pk=";
  };

  vendorHash = "sha256-Oxhraf5xsnowNWZznB6JE+nCnGc3D5dOi/EWIvyv81M=";

  ldflags = [
    "-s"
    "-w"
    "-X main.buildVersion=${version}"
    "-X main.gitCommit=${src.rev}"
  ];

  env.CGO_ENABLED = if stdenv.hostPlatform.isDarwin then "1" else "0";

  subPackages = [
    "cmd/newrelic-infra"
    "cmd/newrelic-infra-ctl"
    "cmd/newrelic-infra-service"
  ];

  meta = {
    description = "New Relic Infrastructure Agent";
    homepage = "https://github.com/newrelic/infrastructure-agent.git";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ davsanchez ];
    mainProgram = "newrelic-infra";
  };
}
