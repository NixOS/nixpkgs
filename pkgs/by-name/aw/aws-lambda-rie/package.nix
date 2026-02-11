{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "aws-lambda-runtime-interface-emulator";
  version = "1.31";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-lambda-runtime-interface-emulator";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-T+a6qbdAtdtihf903C8en4dPChB87Qd32iBbTbUnhkA=";
  };

  vendorHash = "sha256-+7BuDaN1ns63cQOMKuRMjBo9GnLrmsubx/KppUsyheY=";

  # disabled because I lack the skill
  doCheck = false;

  meta = {
    description = "Locally test Lambda functions packaged as container images";
    mainProgram = "aws-lambda-rie";
    homepage = "https://github.com/aws/aws-lambda-runtime-interface-emulator";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
