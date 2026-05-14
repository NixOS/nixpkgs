{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "render-cli";
  version = "2.16.0";

  src = fetchFromGitHub {
    owner = "render-oss";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-y9XlOMNwqdooj3LcNFIF9gov9KX+WtB8eU0NsjzVuUc=";
  };

  vendorHash = "sha256-K2RKcz5wAP0ZA5g5aDgSsEXKEEncFtO9qamgG3fW02Y=";

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
