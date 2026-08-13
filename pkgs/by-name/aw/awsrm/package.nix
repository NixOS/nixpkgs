{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "awsrm";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "jckuester";
    repo = "awsrm";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-KAujqYDtZbCBRO5WK9b9mxqe84ZllbBoO2tLnDH/bdo=";
  };

  vendorHash = "sha256-CldEAeiFH7gdFNLbIe/oTzs8Pdnde7EqLr7vP7SMDGU=";

  ldflags =
    let
      t = "github.com/jckuester/awsrm/internal";
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
    description = "Remove command for AWS resources";
    homepage = "https://github.com/jckuester/awsrm";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.markus1189 ];
    mainProgram = "awsrm";
  };
})
