{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nezha-agent,
  testers,
}:
buildGoModule rec {
  pname = "nezha-agent";
  version = "0.17.2";

  src = fetchFromGitHub {
    owner = "nezhahq";
    repo = "agent";
    rev = "refs/tags/v${version}";
    hash = "sha256-PUBomSo11URCCJB/qFeSHSS3pw/vvcgDBo9Kc0lJQLE=";
  };

  vendorHash = "sha256-wVZWP8yvazxs8sG47MTOlWzKwjsZO/b7PN987fwWEaY=";

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

  meta = {
    description = "Agent of Nezha Monitoring";
    homepage = "https://github.com/nezhahq/agent";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ moraxyc ];
  };
}
