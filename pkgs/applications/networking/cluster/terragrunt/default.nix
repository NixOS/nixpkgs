{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terragrunt";
  version = "0.28.4";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-LilIwg3Zu7Zi7AhJeW0j2qUmSOGy1HHjvvB07FUcEeI=";
  };

  vendorSha256 = "sha256-lRJerUYafpkXAGf8MEM8SeG3aB86mlMo7iLpeHFAnd4=";

  doCheck = false;

  buildFlagsArray = [
    "-ldflags="
    "-s"
    "-w"
    "-X main.VERSION=v${version}"
  ];

  meta = with lib; {
    homepage = "https://terragrunt.gruntwork.io";
    changelog = "https://github.com/gruntwork-io/terragrunt/releases/tag/v${version}";
    description = "A thin wrapper for Terraform that supports locking for Terraform state and enforces best practices";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg jk ];
  };
}
