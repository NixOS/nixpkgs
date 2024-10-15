{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gat";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "koki-develop";
    repo = "gat";
    rev = "refs/tags/v${version}";
    hash = "sha256-wbtTqCSvNGqlliAKdKZyTCeenmcorqQKROAOc4NJal4=";
  };

  vendorHash = "sha256-xLoLLn9lsEZ+SjIbVRzhwM9mXkltfA0Zoiz1T7hpTEc=";

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/koki-develop/gat/cmd.version=v${version}"
  ];

  meta = with lib; {
    description = "Cat alternative written in Go";
    license = licenses.mit;
    homepage = "https://github.com/koki-develop/gat";
    maintainers = with maintainers; [ themaxmur ];
    mainProgram = "gat";
  };
}
