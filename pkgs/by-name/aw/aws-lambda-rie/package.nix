{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "aws-lambda-runtime-interface-emulator";
<<<<<<< HEAD
  version = "1.30";
=======
  version = "1.29";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-lambda-runtime-interface-emulator";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-2GVxcJohh+lLYdx0f4qjIRQNvwKEQNCVD6dQQwNySo8=";
  };

  vendorHash = "sha256-+7BuDaN1ns63cQOMKuRMjBo9GnLrmsubx/KppUsyheY=";
=======
    sha256 = "sha256-iTNo6W533iQmguVd7O955q1LuyixdvVQ79KZyBjb/QE=";
  };

  vendorHash = "sha256-jGz5reViV145GP9Sf8bGabYxVGi194vbvpTpEgUv3t8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # disabled because I lack the skill
  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "Locally test Lambda functions packaged as container images";
    mainProgram = "aws-lambda-rie";
    homepage = "https://github.com/aws/aws-lambda-runtime-interface-emulator";
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    description = "Locally test Lambda functions packaged as container images";
    mainProgram = "aws-lambda-rie";
    homepage = "https://github.com/aws/aws-lambda-runtime-interface-emulator";
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
