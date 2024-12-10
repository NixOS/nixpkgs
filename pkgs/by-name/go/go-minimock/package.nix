{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-minimock";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "gojuno";
    repo = "minimock";
    rev = "v${version}";
    hash = "sha256-YwaC+saod1IoVj6fc6Zucwy83XhnPgqaOp1IcxEmlaw=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  vendorHash = "sha256-0dqbDG/fKaznxeVMSVCEtkQn76dOso6XBiw6xlKqgwM=";

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
