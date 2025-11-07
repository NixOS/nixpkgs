{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "aws-lambda-runtime-interface-emulator";
  version = "1.28";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-lambda-runtime-interface-emulator";
    rev = "v${version}";
    sha256 = "sha256-BEyztLEn2S3gkmb7WV+tZ6Cmjt3/h8mVToSQQ6qjmRo=";
  };

  vendorHash = "sha256-+tgB9Z39Oq43PZoF85DG1Z/CGeoXXTKAML7Z6DZ1XvM=";

  # disabled because I lack the skill
  doCheck = false;

  meta = with lib; {
    description = "Locally test Lambda functions packaged as container images";
    mainProgram = "aws-lambda-rie";
    homepage = "https://github.com/aws/aws-lambda-runtime-interface-emulator";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
