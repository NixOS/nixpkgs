{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule rec {
  pname = "gollama";
  version = "v1.35.3";

  src = fetchFromGitHub {
    owner = "sammcj";
    repo = "gollama";
    tag = "v${version}";
    hash = "sha256-k2SGcsWQi2jC3W2ZO8KXY+WUyh7n7qonLr6BLKZXzdY=";
  };

  vendorHash = "sha256-hZx4AsPnlFmJGms0vRKgBV/4Ea8uvHaNc0zNehs2RB8=";

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
