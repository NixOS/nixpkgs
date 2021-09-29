{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terragrunt";
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FvgB0jG6PEvhrT9Au/Uv9XSgKx+zNw8zETpg2dJ6QX4=";
  };

  vendorSha256 = "sha256-y84EFmoJS4SeA5YFIVFU0iWa5NnjU5yvOj7OFE+jGN0=";

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
