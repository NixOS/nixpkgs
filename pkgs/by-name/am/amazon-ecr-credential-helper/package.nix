{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  amazon-ecr-credential-helper,
}:

buildGoModule (finalAttrs: {
  pname = "amazon-ecr-credential-helper";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "amazon-ecr-credential-helper";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-rsAhDX10eGnmWy6HYoIWn1k64yiC3AcWjCDancBe/VA=";
  };

  vendorHash = null;

  modRoot = "./ecr-login";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/awslabs/amazon-ecr-credential-helper/ecr-login/version.Version=${finalAttrs.version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = amazon-ecr-credential-helper;
    command = "docker-credential-ecr-login -v";
  };

  meta = {
    description = "Amazon ECR Docker Credential Helper is a credential helper for the Docker daemon that makes it easier to use Amazon Elastic Container Registry";
    homepage = "https://github.com/awslabs/amazon-ecr-credential-helper";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kalbasit ];
    mainProgram = "docker-credential-ecr-login";
  };
})
