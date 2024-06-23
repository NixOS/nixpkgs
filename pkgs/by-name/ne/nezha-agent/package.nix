{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nezha-agent,
  testers,
}:
buildGoModule rec {
  pname = "nezha-agent";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "nezhahq";
    repo = "agent";
    rev = "v${version}";
    hash = "sha256-xCoCmWdliw7zSxLv8IJl2F03TPMS3dRC40JH1XBirTI=";
  };

  vendorHash = "sha256-V5ykn/0vXSrCtCX4EEoThXMKE6EVTjc9zXt89G+34N8=";

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
