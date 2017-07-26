{ stdenv, lib, buildGoPackage, fetchFromGitHub, terraform, makeWrapper }:

buildGoPackage rec {
  name = "terragrunt-${version}";
  version = "0.11.1";

  goPackagePath = "github.com/gruntwork-io/terragrunt";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "gruntwork-io";
    repo   = "terragrunt";
    sha256 = "061ix4m64i8bvjpqm6hn83nnkvqrp5y0hh5gzmxiik2nz3by1rx5";
  };

  goDeps = ./deps_0_11.nix;

  buildInputs = [ makeWrapper ];

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-X main.VERSION=v${version}")
  '';

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
