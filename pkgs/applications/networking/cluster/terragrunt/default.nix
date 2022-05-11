{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terragrunt";
  version = "0.36.11";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kXa3iG94WTH6KpQksl2r0yXyr4KuLY2AZdZtZ6zWYUA=";
  };

  vendorSha256 = "sha256-7SUf4r+6r6dkBoBZFg2AUK114QEl0+1lwRA4ymYArFs=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.VERSION=v${version}" ];

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
    maintainers = with maintainers; [ jk ];
  };
}
