{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  amazon-ecr-credential-helper,
}:

buildGoModule rec {
  pname = "amazon-ecr-credential-helper";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "amazon-ecr-credential-helper";
    rev = "v${version}";
    sha256 = "sha256-TRYBZiddnN6wCErSLKCr9JEH/Ldxg+Oh2hA63+EwRjo=";
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

  meta = with lib; {
    description = "Amazon ECR Docker Credential Helper is a credential helper for the Docker daemon that makes it easier to use Amazon Elastic Container Registry";
    homepage = "https://github.com/awslabs/amazon-ecr-credential-helper";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit ];
    mainProgram = "docker-credential-ecr-login";
  };
}
