{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule rec {
  pname = "gollama";
  version = "v2.0.1";

  src = fetchFromGitHub {
    owner = "sammcj";
    repo = "gollama";
    tag = "v${version}";
    hash = "sha256-6r0mAimyFxQ/cJyB9vMJeP6S5cEdzzfb5axXfeOE1nU=";
  };

  vendorHash = "sha256-eOxEq+4JQCCWpnVy7aKM9GiZ29bzvfsrqXD4Op8+/K4=";

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
