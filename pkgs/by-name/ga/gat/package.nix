{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gat";
  version = "0.20.3";

  src = fetchFromGitHub {
    owner = "koki-develop";
    repo = "gat";
    tag = "v${version}";
    hash = "sha256-97rFnJPdnLv8RLI5ZGMpdEX2UwLUNBVn3Fe4vv5MFRY=";
  };

  vendorHash = "sha256-C3iUsS1p/+8U1KO/B5htYwCKnQThOusjE/jhOqoCFQo=";

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
