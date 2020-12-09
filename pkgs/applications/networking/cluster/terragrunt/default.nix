{ lib, buildGoModule, fetchFromGitHub, makeWrapper }:

buildGoModule rec {
  pname = "terragrunt";
  version = "0.26.7";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "1431n6zs2mfkgh281xi0d7m9hxifrrsnd46fnpb54mr6lj9h0sdb";
  };

  vendorSha256 = "18ix11g709fvh8h02k3p2bmzrq5fjzaqa50h3g74s3hyl2gc9s9h";

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
