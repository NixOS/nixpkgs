{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "2.3.1";
in
buildGoModule {
  name = "fork-cleaner";
  inherit version;

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "fork-cleaner";
    rev = "v${version}";
    sha256 = "sha256-JNmpcDwmxR+s4regOWz8FAJllBNRfOCmVwkDs7tlChA=";
  };

  vendorHash = "sha256-QuIaXXkch5PCpX8P755X8j7MeNnbewWo7NB+Vue1/Pk=";

  # allowGoRefence adds the flag `-trimpath` which is also denoted by, fork-cleaner goreleaser config
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
