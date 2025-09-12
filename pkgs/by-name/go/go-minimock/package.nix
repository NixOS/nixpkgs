{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-minimock";
  version = "3.4.6";

  src = fetchFromGitHub {
    owner = "gojuno";
    repo = "minimock";
    rev = "v${version}";
    hash = "sha256-jbl8ngVagwbDSIZFrMtRRCHvQ0e6mojrk4rXJ/HsJSk=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  vendorHash = "sha256-74bmsixBO5VwLZYRXN9Fx3Mu9BbL4bSF6o0h9QaET1Y=";

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
