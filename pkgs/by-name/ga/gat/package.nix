{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gat";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "koki-develop";
    repo = "gat";
    rev = "refs/tags/v${version}";
    hash = "sha256-aQ7EEB+yJ78vT/LskYsnUya6rIID1AvdaUWzr1oWV3k=";
  };

  vendorHash = "sha256-q6g3pXWKIWanGPxOxsKUEuP8Hcc31GCm64RbOAhQTfE=";

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
