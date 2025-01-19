{
  lib,
  buildGoModule,
  fetchFromGitHub,
  chromium,
  makeWrapper,
}:

buildGoModule rec {
  pname = "grafana-kiosk";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "grafana-kiosk";
    rev = "v${version}";
    hash = "sha256-M0Gz0+MQNTIOYBxVRaxk5kYZwoJy1nPckGcYF29EzHA=";
  };

  vendorHash = "sha256-dnA5Z6VX7+RLpV7+PPuckH+v407dK8nbe0OVJtfG1YE=";

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
