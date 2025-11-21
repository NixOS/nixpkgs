{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "aws-lambda-runtime-interface-emulator";
  version = "1.29";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-lambda-runtime-interface-emulator";
    rev = "v${version}";
    sha256 = "sha256-iTNo6W533iQmguVd7O955q1LuyixdvVQ79KZyBjb/QE=";
  };

  vendorHash = "sha256-jGz5reViV145GP9Sf8bGabYxVGi194vbvpTpEgUv3t8=";

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
