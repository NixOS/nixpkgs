{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nezha-agent";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "nezhahq";
    repo = "agent";
    rev = "v${version}";
    hash = "sha256-YumfGpKoThKqodk+D/7hBMegzZpdc5x3KiwwQEY3Gx0=";
  };

  vendorHash = "sha256-qbJdPDFC5OvJRhHP8qAY7QSTIPACanUBA9F9UK3vm5Y=";

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
    maintainers = with maintainers; [ moraxyc ];
  };
}
