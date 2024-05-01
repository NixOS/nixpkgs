{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "grafana-kiosk";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "grafana-kiosk";
    rev = "v${version}";
    hash = "sha256-KXEbhRFD++VeVI1Fbrai+IYb3lyGKs+plYPoKIZD0JM=";
  };

  vendorHash = "sha256-sXaxyPNuHDUOkYcWYm94YvJmr1mGe4HdzttWrNSK2Pw=";

  meta = with lib; {
    description = "Kiosk Utility for Grafana";
    homepage = "https://github.com/grafana/grafana-kiosk";
    license = licenses.asl20;
    maintainers = with maintainers; [ marcusramberg ];
    mainProgram = "grafana-kiosk";
  };
}
