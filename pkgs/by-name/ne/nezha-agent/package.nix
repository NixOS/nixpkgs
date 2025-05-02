{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nezha-agent,
  testers,
}:
buildGoModule rec {
  pname = "nezha-agent";
  version = "0.16.5";

  src = fetchFromGitHub {
    owner = "nezhahq";
    repo = "agent";
    rev = "v${version}";
    hash = "sha256-WRHYI3/6qrVZRa4ANA6VBBJCaINP1N8Xjy0GWO4LqgA=";
  };

  vendorHash = "sha256-AtcRfvYBgTZJz9dpsMgacnV8RNi2Ph7QgUrcE6zzTo8=";

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
