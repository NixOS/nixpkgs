{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terragrunt";
  version = "0.27.4";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ReLPQIxuSTzMOZAYArN1dj6T/aojusKdKZ0YytmF1uc=";
  };

  vendorSha256 = "sha256-UX0HXD4o0QVRffDuH8N+1FeJNyHHnb+A9Kw7aAM5j/w=";

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
