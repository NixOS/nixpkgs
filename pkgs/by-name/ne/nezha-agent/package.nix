{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nezha-agent,
  testers,
}:
buildGoModule rec {
  pname = "nezha-agent";
  version = "0.16.8";

  src = fetchFromGitHub {
    owner = "nezhahq";
    repo = "agent";
    rev = "v${version}";
    hash = "sha256-s3l6sI+gQcy5Qxjzg+l9t9e8WWYppiMljX7o1rSXFIs=";
  };

  vendorHash = "sha256-Qx0XAlWLDqN1CZTmf1yVc8yFmz9/5bz/HVqN/korJzE=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  # The test failed due to a geoip request in the sandbox. Remove it to avoid network requirement
  preCheck = ''
    rm ./pkg/monitor/myip_test.go
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = nezha-agent;
      command = "${nezha-agent}/bin/agent -v";
    };
  };

  meta = with lib; {
    description = "Agent of Nezha Monitoring";
    homepage = "https://github.com/nezhahq/agent";
    license = licenses.asl20;
    maintainers = with maintainers; [ moraxyc ];
  };
}
