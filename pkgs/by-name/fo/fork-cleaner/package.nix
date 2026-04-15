{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "2.4.0";
in
buildGoModule {
  pname = "fork-cleaner";
  inherit version;

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "fork-cleaner";
    rev = "v${version}";
    hash = "sha256-Io/IOJYa9qDCTTf6vQvZeco1iEDV7crnvzR539QDz40=";
  };

  vendorHash = "sha256-+OlrXYjBiXtbMf/IRzj06J1yq2XdlQk54lnJtCmqymw=";

  # allowGoReference adds the flag `-trimpath` which is also denoted by, fork-cleaner goreleaser config
  #  <https://github.com/caarlos0/fork-cleaner/blob/645345bf97d751614270de4ade698ddbc53509c1/goreleaser.yml#L38>
  allowGoReference = true;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.builtBy=nixpkgs"
  ];

  meta = {
    description = "Quickly clean up unused forks on your GitHub account";
    homepage = "https://github.com/caarlos0/fork-cleaner";
    changelog = "https://github.com/caarlos0/fork-cleaner/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "fork-cleaner";
  };
}
