{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule rec {
  pname = "gollama";
  version = "v2.0.4";

  src = fetchFromGitHub {
    owner = "sammcj";
    repo = "gollama";
    tag = "v${version}";
    hash = "sha256-unvnFKkEWJnyzuNz8zekB8ZSXP/dUqv24qgyhkP3kkY=";
  };

  vendorHash = "sha256-t7Kl6WnS8vvLyvKzkDswv0yOaeTE3IgZCNAC3dD8euU=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Go manage your Ollama models";
    homepage = "https://github.com/sammcj/gollama";
    changelog = "https://github.com/sammcj/gollama/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "gollama";
  };
}
