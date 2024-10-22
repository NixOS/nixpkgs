{ lib, buildGoModule, fetchFromGitHub, chromium, makeWrapper }:

buildGoModule rec {
  pname = "grafana-kiosk";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "grafana-kiosk";
    rev = "v${version}";
    hash = "sha256-JTz3EaedJFWE3YqsBLjKH4hWI7+dNeMlp0sZ2kW8IR8=";
  };

  vendorHash = "sha256-8sxfbSj0Jq5f0oJoe8PtP72PDWvLzgOeRiP7I/Pfam4=";

  nativeBuildInputs = [ makeWrapper ];
  postFixup = ''
    wrapProgram $out/bin/grafana-kiosk --prefix PATH : ${lib.makeBinPath [ chromium ]}
  '';

  meta = with lib; {
    description = "Kiosk Utility for Grafana";
    homepage = "https://github.com/grafana/grafana-kiosk";
    changelog = "https://github.com/grafana/grafana-kiosk/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ marcusramberg ];
    mainProgram = "grafana-kiosk";
  };
}
