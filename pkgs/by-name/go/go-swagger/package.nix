{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-swagger";
  version = "0.32.3";

  src = fetchFromGitHub {
    owner = "go-swagger";
    repo = "go-swagger";
    tag = "v${version}";
    hash = "sha256-L6EfHNwykqGtA1CZd/Py6QqeCz10VGjX/lEVHs6VB6g=";
  };

  vendorHash = "sha256-UQbPVrLehl2jwGXdJPrRo6JsAd/2A+NKEQwkRr3reOY=";

  doCheck = false;

  subPackages = [ "cmd/swagger" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/go-swagger/go-swagger/cmd/swagger/commands.Version=${version}"
    "-X github.com/go-swagger/go-swagger/cmd/swagger/commands.Commit=${src.rev}"
  ];

  meta = {
    description = "Golang implementation of Swagger 2.0, representation of your RESTful API";
    homepage = "https://github.com/go-swagger/go-swagger";
    changelog = "https://github.com/go-swagger/go-swagger/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kalbasit ];
    mainProgram = "swagger";
  };
}
