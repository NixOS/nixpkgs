{ stdenv, lib, buildGoPackage, fetchFromGitHub, terraform, makeWrapper }:

buildGoPackage rec {
  name = "terragrunt-${version}";
  version = "0.9.3";

  goPackagePath = "github.com/gruntwork-io/terragrunt";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "gruntwork-io";
    repo   = "terragrunt";
    sha256 = "0i6sqgyxhi6icp7nps9prc40m9wsbr71v967kgl2865sgb214rdx";
  };

  goDeps = ./deps.nix;

  buildInputs = [ makeWrapper terraform ];

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
