{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "render-cli";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "render-oss";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-SvWU88VwTLYUmVfG5/qs7jazIX7hjV4x+6ZT/7ZBKuQ=";
  };

  vendorHash = "sha256-BExwkK0EKR0Mtk+bphPD3/4iyAnj942gkGWWTYUIceU=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/render-oss/cli/pkg/cfg.Version=${version}"
  ];

  # Skip network-dependent tests that fail in sandbox
  checkFlags = [
    "-skip"
    "TestE2E|TestClient_NewVersionAvailable"
  ];

  doCheck = true;

  postInstall = ''
    mv $out/bin/{cli,render}
  '';

  meta = {
    description = "Official CLI for Render cloud platform";
    homepage = "https://github.com/render-oss/cli";
    changelog = "https://github.com/render-oss/cli/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tennox ];
    mainProgram = "render";
    platforms = lib.platforms.unix;
  };
}
