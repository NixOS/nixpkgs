{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go-swagger";
  version = "0.33.2";

  src = fetchFromGitHub {
    owner = "go-swagger";
    repo = "go-swagger";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8BMO7rItteXSc0qdfjrgYN/Zfm2hIzTvI2SHY3nxyX4=";
  };

  vendorHash = "sha256-3eebNmeYz207chEej/2jcjgqq/zcckm1KwuWHA8O6cw=";

  doCheck = false;

  subPackages = [ "cmd/swagger" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/go-swagger/go-swagger/cmd/swagger/commands.Version=${finalAttrs.version}"
    "-X github.com/go-swagger/go-swagger/cmd/swagger/commands.Commit=${finalAttrs.src.rev}"
  ];

  meta = {
    description = "Golang implementation of Swagger 2.0, representation of your RESTful API";
    homepage = "https://github.com/go-swagger/go-swagger";
    changelog = "https://github.com/go-swagger/go-swagger/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kalbasit ];
    mainProgram = "swagger";
  };
})
