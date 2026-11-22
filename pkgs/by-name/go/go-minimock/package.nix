{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go-minimock";
  version = "3.4.7";

  src = fetchFromGitHub {
    owner = "gojuno";
    repo = "minimock";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Dx4m17r7GOdiaV8DzqOXAr32dNCXJyi7gID6GHohKXk=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  vendorHash = "sha256-74bmsixBO5VwLZYRXN9Fx3Mu9BbL4bSF6o0h9QaET1Y=";

  doCheck = true;

  subPackages = [
    "cmd/minimock"
    "."
  ];

  meta = {
    homepage = "https://github.com/gojuno/minimock";
    description = "Golang mock generator from interfaces";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ svrana ];
    mainProgram = "minimock";
  };
})
