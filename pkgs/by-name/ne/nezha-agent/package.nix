{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nezha-agent";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "nezhahq";
    repo = "agent";
    rev = "v${version}";
    hash = "sha256-dg6GBNbCnC94h0b/NzFQBBAE8YwfWRtBTlgQ370+zko=";
  };

  vendorHash = "sha256-kMRbbaIgP6LiXHAbUw6BBSr9ISNyWSZpFhlQCYQB3ig=";

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
