{ stdenv, lib, buildGoPackage, fetchFromGitHub, terraform, makeWrapper }:

buildGoPackage rec {
  name = "terragrunt-${version}";
  version = "0.10.1";

  goPackagePath = "github.com/gruntwork-io/terragrunt";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "gruntwork-io";
    repo   = "terragrunt";
    sha256 = "04q9wm8dnbm1pcy9i3c7ral49k3z10a7gx7h6h4bsvjy1sdf58vz";
  };

  goDeps = ./deps.nix;

  buildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $bin/bin/terragrunt \
      --set TERRAGRUNT_TFPATH ${lib.getBin terraform}/bin/terraform
  '';

  meta = with stdenv.lib; {
    description = "A thin wrapper for Terraform that supports locking for Terraform state and enforces best practices.";
    homepage = https://github.com/gruntwork-io/terragrunt/;
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
