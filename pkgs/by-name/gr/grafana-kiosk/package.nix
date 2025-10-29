{
  lib,
  buildGoModule,
  fetchFromGitHub,
  chromium,
  makeWrapper,
}:

buildGoModule rec {
  pname = "grafana-kiosk";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "grafana-kiosk";
    rev = "v${version}";
    hash = "sha256-kh62qGMVHNTssQMEBwLaEW0tRtP3iWMrxXeQU+fe+44=";
  };

  vendorHash = "sha256-LZLmXGPYvNR4meqen0h0UHj62392hfPs9BLNK+X6sKA=";

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
