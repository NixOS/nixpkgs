{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "terragrunt";
  version = "0.55.12";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-RwPpABQnfcMfOMZm2PPT3w03HU8Y73leI+xxlHqZF10=";
  };

  vendorHash = "sha256-sdEA/5QQ85tGfo7qSCD/lD20uAh045fl3tF9nFfH6x0=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/gruntwork-io/go-commons/version.Version=v${version}"
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
    maintainers = with maintainers; [ jk qjoly kashw2 ];
  };
}
