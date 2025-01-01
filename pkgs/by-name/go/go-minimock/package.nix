{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-minimock";
  version = "3.4.3";

  src = fetchFromGitHub {
    owner = "gojuno";
    repo = "minimock";
    rev = "v${version}";
    hash = "sha256-K7b77EqcXl4fZcpp93Jwg3fXLVmDuantv4QJYHj/Fik=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  vendorHash = "sha256-zk5ulVxn7qAsU5i5z6eG0OMN5ExSu/ceBKu8UMwoiPo=";

  doCheck = true;

  subPackages = [
    "cmd/minimock"
    "."
  ];

  meta = with lib; {
    homepage = "https://github.com/gojuno/minimock";
    description = "Golang mock generator from interfaces";
    license = licenses.mit;
    maintainers = with maintainers; [ svrana ];
    mainProgram = "minimock";
  };
}
