{
  lib,
  buildGoModule,
  fetchFromGitHub,
  chromium,
  makeWrapper,
}:

buildGoModule rec {
  pname = "grafana-kiosk";
  version = "1.0.10";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "grafana-kiosk";
    rev = "v${version}";
    hash = "sha256-dp+yKpPm11/LfRXjgFZrDAwstnz6vALJBANBqwlEXFo=";
  };

  vendorHash = "sha256-3ctFiBgR7Lzhy7M3USWD3mv6FZ6cSfdjHhtOVFNLQag=";

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
