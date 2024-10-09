{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nezha-agent,
  testers,
}:
buildGoModule rec {
  pname = "nezha-agent";
  version = "0.19.10";

  src = fetchFromGitHub {
    owner = "nezhahq";
    repo = "agent";
    rev = "refs/tags/v${version}";
    hash = "sha256-tOfk341Eo2bOcGGaQJmQUcfan4HIcgs7+EwHrurG/Fg=";
  };

  vendorHash = "sha256-q6/265vVg6jCnDvs825nni8QFHkJpQz4xxC9MlJH2do=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  # The test failed due to a geoip request in the sandbox. Remove it to avoid network requirement
  # preCheck = ''
  #   rm ./pkg/monitor/myip_test.go
  # '';

  patches = [
    ./fixnet.patch
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = nezha-agent;
      command = "${nezha-agent}/bin/agent -v";
    };
  };

  meta = {
    description = "Agent of Nezha Monitoring";
    homepage = "https://github.com/nezhahq/agent";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ moraxyc ];
  };
}
