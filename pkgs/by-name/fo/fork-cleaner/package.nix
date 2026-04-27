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
    tag = "v${version}";
    hash = "sha256-Io/IOJYa9qDCTTf6vQvZeco1iEDV7crnvzR539QDz40=";
  };

  vendorHash = "sha256-+OlrXYjBiXtbMf/IRzj06J1yq2XdlQk54lnJtCmqymw=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.builtBy=nixpkgs"
  ];

  meta = {
    description = "Quickly clean up unused forks on your GitHub account";
    homepage = "https://github.com/caarlos0/fork-cleaner";
    changelog = "https://github.com/caarlos0/fork-cleaner/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "fork-cleaner";
  };
}
