{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gat";
  version = "0.23.2";

  src = fetchFromGitHub {
    owner = "koki-develop";
    repo = "gat";
    tag = "v${version}";
    hash = "sha256-vJREExCJ+JvPYxNeJWQ6A4LRB2viEisnXrRM6yDGOc4=";
  };

  vendorHash = "sha256-yGTzDlu9l1Vfnt9Za4Axh7nFWe5CmW2kqssa+51bA3w=";

  env.CGO_ENABLED = 0;

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
