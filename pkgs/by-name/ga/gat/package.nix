{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gat";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "koki-develop";
    repo = "gat";
    tag = "v${version}";
    hash = "sha256-be6pV8e1Grw7HSvGrJN4ukCpI+Xu4nKN+ITtb+saVgw=";
  };

  vendorHash = "sha256-AaDFeDZMMDrIRqYFR+b4nrmLf13KUMEEE1zUHpVQxTg=";

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
