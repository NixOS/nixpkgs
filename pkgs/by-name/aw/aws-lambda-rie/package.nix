{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "aws-lambda-runtime-interface-emulator";
  version = "1.38";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-lambda-runtime-interface-emulator";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-8FEaz2uL+GX70qGRmGcCWnXYb87b4aaBLAfirLZZPJQ=";
  };

  vendorHash = "sha256-vC3x2Bd246zAJDKP26Whbz34G/mgjuYBJIAjDyOsonw=";

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
