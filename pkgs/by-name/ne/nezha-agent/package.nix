{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "nezha-agent";
  version = "0.16.2";

  src = fetchFromGitHub {
    owner = "nezhahq";
    repo = "agent";
    rev = "v${version}";
    hash = "sha256-IeD0jEsXsICTTr+6VsOLtH+HZpVk8DR55Z+sv/S28hs=";
  };

  vendorHash = "sha256-Cat731ODnHIfbizDcOztmyIXOBSWPHT/0Pf4XuG+7TI=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  checkPhase = ''
    runHook preCheck
    export GOFLAGS=''${GOFLAGS//-trimpath/}
    rm ./pkg/monitor/myip_test.go
    for pkg in $(getGoDirs test); do
      buildGoDir test "$pkg"
    done
    runHook postCheck
  '';

  meta = with lib; {
    description = "Agent of Nezha Monitoring";
    homepage = "https://github.com/nezhahq/agent";
    license = licenses.asl20;
    maintainers = with maintainers; [moraxyc];
  };
}
