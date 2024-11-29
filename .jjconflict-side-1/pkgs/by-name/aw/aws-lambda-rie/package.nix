{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "aws-lambda-runtime-interface-emulator";
  version = "1.20";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-lambda-runtime-interface-emulator";
    rev = "v${version}";
    sha256 = "sha256-cpfzjXjufiCe6AJsTj08vJ719MztHwY+6fMnk8vR82k=";
  };

  vendorHash = "sha256-fGoqKDBg+O4uzGmhEIROsBvDS+6zWCzsXe8U6t98bqk=";

  # disabled because I lack the skill
  doCheck = false;

  meta = with lib; {
    description = "Locally test Lambda functions packaged as container images";
    mainProgram = "aws-lambda-rie";
    homepage = "https://github.com/aws/aws-lambda-runtime-interface-emulator";
    license = licenses.asl20;
    maintainers = with maintainers; [ teto ];
  };
}
