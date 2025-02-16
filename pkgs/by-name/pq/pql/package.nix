{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pql";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "runreveal";
    repo = "pql";
    rev = "v${version}";
    hash = "sha256-xNWwjDdnF4+IvS814iJlqCFYNOGNF2nHEnnbRqxJsjM=";
  };

  vendorHash = "sha256-j/R+1PWfX+lmm99cHWSuo+v8RxKg089Bvb4rFHpmpfE=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Pipelined Query Language";
    homepage = "https://github.com/runreveal/pql";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "pql";
  };
}
