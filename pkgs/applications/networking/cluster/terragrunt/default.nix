{ lib, buildGoModule, fetchFromGitHub, makeWrapper }:

buildGoModule rec {
  pname = "terragrunt";
  version = "0.26.5";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wnczg234jys54njaxbf9dd7b299dyl4spjpr5l40agz9cd8mkq3";
  };

  vendorSha256 = "0l85jx02dj9qvxs8l0ln5fln8vssi0fisblm5i1scz9x4a1jqg9n";

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
