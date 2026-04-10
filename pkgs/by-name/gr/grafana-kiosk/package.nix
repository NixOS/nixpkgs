{
  lib,
  buildGoModule,
  fetchFromGitHub,
  chromium,
  makeWrapper,
}:

buildGoModule (finalAttrs: {
  pname = "grafana-kiosk";
  version = "1.0.11";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "grafana-kiosk";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+LoUJiMqE/OO0J7zIy+8uvQUq1wFpGvNvxzhb4pj+r8=";
  };

  vendorHash = "sha256-+tslKo5onMgnEtitYi9uwO4m5MUGzctJ7Vt4C7hJ7Fc=";

  nativeBuildInputs = [ makeWrapper ];
  postFixup = ''
    wrapProgram $out/bin/grafana-kiosk --prefix PATH : ${lib.makeBinPath [ chromium ]}
  '';

  meta = {
    description = "Kiosk Utility for Grafana";
    homepage = "https://github.com/grafana/grafana-kiosk";
    changelog = "https://github.com/grafana/grafana-kiosk/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ marcusramberg ];
    mainProgram = "grafana-kiosk";
  };
})
