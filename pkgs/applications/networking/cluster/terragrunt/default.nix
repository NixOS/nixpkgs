{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terragrunt";
  version = "0.28.7";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-pM3R85gdP2eVoXx//2tKePNAi14eM8Ut+eXR+vB0Ukk=";
  };

  vendorSha256 = "sha256-lRJerUYafpkXAGf8MEM8SeG3aB86mlMo7iLpeHFAnd4=";

  doCheck = false;

  buildFlagsArray = [
    "-ldflags="
    "-s"
    "-w"
    "-X main.VERSION=v${version}"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/terragrunt --help
    $out/bin/terragrunt --version | grep "v${version}"
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://terragrunt.gruntwork.io";
    changelog = "https://github.com/gruntwork-io/terragrunt/releases/tag/v${version}";
    description = "A thin wrapper for Terraform that supports locking for Terraform state and enforces best practices";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg jk ];
  };
}
