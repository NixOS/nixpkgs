{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go-swagger";
  version = "0.36.5";

  src = fetchFromGitHub {
    owner = "go-swagger";
    repo = "go-swagger";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4EBmCMOCAtpyDmNxlPpnIpUBlQaF+0GIIum1QHT8OrA=";
  };

  vendorHash = "sha256-AUNPwDqJeJuVB3h9igx9+MN44qIqab7cX3U7XT/vow0=";

  doCheck = false;

  subPackages = [ "cmd/swagger" ];

  ldflags = [
    "-s"
    "-X=github.com/go-swagger/go-swagger/cmd/swagger/commands.Version=${finalAttrs.version}"
    "-X=github.com/go-swagger/go-swagger/cmd/swagger/commands.Commit=${finalAttrs.src.rev}"
  ];

  meta = {
    description = "Golang implementation of Swagger 2.0, representation of your RESTful API";
    homepage = "https://github.com/go-swagger/go-swagger";
    changelog = "https://github.com/go-swagger/go-swagger/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kalbasit ];
    mainProgram = "swagger";
  };
})
