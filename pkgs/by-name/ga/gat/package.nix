{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gat";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "koki-develop";
    repo = "gat";
    tag = "v${version}";
    hash = "sha256-lqMK/lHnHipX5COpY0rVPhDL196lomT09w9cAzPCwA8=";
  };

  vendorHash = "sha256-gePgJZdPuV6VTgyLKTjRohxoIdvBr7/J98FCp9dzjV0=";

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
