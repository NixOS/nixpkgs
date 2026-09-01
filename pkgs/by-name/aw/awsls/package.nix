{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "awsls";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "jckuester";
    repo = "awsls";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-iy9tohmVUtNXYVfe6pZ+pbbLlcK6Fu1GgzTWMD+3xP0=";
  };

  vendorHash = "sha256-ZyMO+KCqoePF6MqHFt8X4tZR4nBhuSPgJDrX+emM6jc=";

  ldflags =
    let
      t = "github.com/jckuester/awsls/internal";
    in
    [
      "-s"
      "-w"
      "-X ${t}.version=${finalAttrs.version}"
      "-X ${t}.commit=${finalAttrs.src.rev}"
      "-X ${t}.date=unknown"
    ];

  doCheck = false;

  meta = {
    description = "List command for AWS resources";
    homepage = "https://github.com/jckuester/awsls";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.markus1189 ];
    mainProgram = "awsls";
  };
})
