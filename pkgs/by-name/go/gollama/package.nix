{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule rec {
  pname = "gollama";
  version = "1.33.0";

  src = fetchFromGitHub {
    owner = "sammcj";
    repo = "gollama";
    tag = "v${version}";
    hash = "sha256-hgIOOBfE9t1/oUmFvmtHyuWaOgftzxCiT3xmEJ6d45I=";
  };

  vendorHash = "sha256-AE3uD9Si4Gm1W+jIvwg9kQFqqgJQLAh7eLPs8qtJAGI=";

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
