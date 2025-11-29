{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "jq-lsp";
  version = "0.1.15";

  src = fetchFromGitHub {
    owner = "wader";
    repo = "jq-lsp";
    tag = "v${version}";
    hash = "sha256-5z5CTamk13QL50Hof2XeQ02NqRWMh4cECDhD6egGcnE=";
  };

  vendorHash = "sha256-oiy80U6WmpG0lHl5yTF017gZbiB2cWuM+cQJB0bs+RU=";

  # based on https://github.com/wader/jq-lsp/blob/master/.goreleaser.yml
  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=${src.rev}"
    "-X main.builtBy=Nix"
  ];

  meta = with lib; {
    description = "jq language server";
    homepage = "https://github.com/wader/jq-lsp";
    license = licenses.mit;
    maintainers = with maintainers; [ sysedwinistrator ];
    mainProgram = "jq-lsp";
  };
}
