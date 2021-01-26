{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terragrunt";
  version = "0.27.3";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-J1kwcguBSHTsU/kGviQaj/cX6PpZGs3UI2AJy5+/pCc=";
  };

  vendorSha256 = "sha256-AMxBzUHRsq1HOMtvgYqIw22Cky7gQ7/2hI8wQnxaXb0=";

  doCheck = false;

  buildFlagsArray = [
    "-ldflags="
    "-s"
    "-w"
    "-X main.VERSION=v${version}"
  ];

  meta = with lib; {
    description = "A thin wrapper for Terraform that supports locking for Terraform state and enforces best practices";
    homepage = "https://github.com/gruntwork-io/terragrunt/";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg jk ];
  };
}
