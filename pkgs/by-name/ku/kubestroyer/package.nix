{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubestroyer";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "Rolix44";
    repo = "Kubestroyer";
    tag = "v${version}";
    hash = "sha256-A4kx0Xx3p9rP8OKRLPe9AfX+rqGggtvPb7Hsg+lLkSI=";
  };

  vendorHash = "sha256-V6qEvMsX7tdhooW116+0ayT6RYkdjDbz6QwWb8rC4ig=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Kubernetes exploitation tool";
    homepage = "https://github.com/Rolix44/Kubestroyer";
    changelog = "https://github.com/Rolix44/Kubestroyer/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "kubestroyer";
  };
}
