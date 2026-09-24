{
  lib,
  buildGoModule,
  fetchFromGitHub,
  chromium,
  makeWrapper,
}:

buildGoModule (finalAttrs: {
  pname = "grafana-kiosk";
  version = "1.0.12";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "grafana-kiosk";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NfLS7N1J71HnDx3oTfWf3lsWp3XNx18Jk7qwNPMfOZA=";
  };

  vendorHash = "sha256-Czxxuy4ptsUx9cqog6wsHkUzS+j7WGj8PGsa4MDRJEE=";

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
