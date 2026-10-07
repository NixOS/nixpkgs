{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "render-cli";
  version = "2.24.0";

  src = fetchFromGitHub {
    owner = "render-oss";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-n0umMoIhJsWYliqt6ABjR13DAeIceI946nfCpQ26yOw=";
  };

  vendorHash = "sha256-VIIRQ6Vq5UjLlbWc4BbUi48FMpOhx7ZeHezSKe/Houc=";

  # Tests require network access
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/render-oss/cli/pkg/cfg.Version=${version}"
  ];

  postInstall = ''
    mv $out/bin/cli $out/bin/render
  '';

  meta = {
    description = "Official command-line interface for Render cloud hosting platform";
    homepage = "https://github.com/render-oss/cli";
    changelog = "https://github.com/render-oss/cli/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jtamagnan ];
    mainProgram = "render";
  };
}
