{
  lib,
  buildGoModule,
  fetchFromGitHub,
  chromium,
  makeWrapper,
}:

buildGoModule (finalAttrs: {
  pname = "grafana-kiosk";
  version = "1.0.13";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "grafana-kiosk";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6dW3uzFnNKKgvjZLweMQYkOXn7nEVFwos9CcZnv1Eso=";
  };

  vendorHash = "sha256-EFk/0KFopbnRGxeY9e6Zqf3nAyoX0SZijkUsSN8nw78=";

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
