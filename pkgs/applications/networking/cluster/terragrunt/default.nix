{ lib, buildGoModule, fetchFromGitHub, makeWrapper }:

buildGoModule rec {
  pname = "terragrunt";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MbhJ1f6Da+kkkCV85kH8Yv74cMzp7JvxeQb0By9aGp8=";
  };

  vendorSha256 = "sha256-AMxBzUHRsq1HOMtvgYqIw22Cky7gQ7/2hI8wQnxaXb0=";

  doCheck = false;

  buildInputs = [ makeWrapper ];

  buildFlagsArray = [ "-ldflags=" "-X main.VERSION=v${version}" ];

  meta = with lib; {
    description = "A thin wrapper for Terraform that supports locking for Terraform state and enforces best practices";
    homepage = "https://github.com/gruntwork-io/terragrunt/";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg jk ];
  };
}
