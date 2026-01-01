{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  amazon-ecr-credential-helper,
}:

buildGoModule rec {
  pname = "amazon-ecr-credential-helper";
<<<<<<< HEAD
  version = "0.11.0";
=======
  version = "0.10.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "amazon-ecr-credential-helper";
    tag = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-rsAhDX10eGnmWy6HYoIWn1k64yiC3AcWjCDancBe/VA=";
=======
    sha256 = "sha256-ZlGXcU3oh/90lP6AjeaFvroZGHUIm0TPoKiKaYMGifA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  vendorHash = null;

  modRoot = "./ecr-login";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/awslabs/amazon-ecr-credential-helper/ecr-login/version.Version=${version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = amazon-ecr-credential-helper;
    command = "docker-credential-ecr-login -v";
  };

<<<<<<< HEAD
  meta = {
    description = "Amazon ECR Docker Credential Helper is a credential helper for the Docker daemon that makes it easier to use Amazon Elastic Container Registry";
    homepage = "https://github.com/awslabs/amazon-ecr-credential-helper";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kalbasit ];
=======
  meta = with lib; {
    description = "Amazon ECR Docker Credential Helper is a credential helper for the Docker daemon that makes it easier to use Amazon Elastic Container Registry";
    homepage = "https://github.com/awslabs/amazon-ecr-credential-helper";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "docker-credential-ecr-login";
  };
}
