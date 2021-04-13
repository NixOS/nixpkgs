{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terragrunt";
  version = "0.28.20";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Hg4eeLFNm2cXUjp3T2VK6q+mgawqkHju9P3Vq9wnB9c=";
  };

  vendorSha256 = "sha256-kcRM76xfajtQist1aJTmaRludxRlfvHQ9ucB3LOgnBk=";

  doCheck = false;

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-s -w -X main.VERSION=v${version}")
  '';

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
