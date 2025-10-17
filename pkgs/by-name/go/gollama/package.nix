{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule rec {
  pname = "gollama";
  version = "v1.37.3";

  src = fetchFromGitHub {
    owner = "sammcj";
    repo = "gollama";
    tag = "v${version}";
    hash = "sha256-TSQmdZTXjRK2Y6GbbAwBuIz6e16vymonEQgbIV9FIGE=";
  };

  vendorHash = "sha256-9DFCMWbLKwqZ/1DSIvMhyUwAy1z9Zo6fIGrncUp51q4=";

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
