{ stdenv, lib, buildGoPackage, fetchFromGitHub, terraform-full, makeWrapper }:

buildGoPackage rec {
  name = "terragrunt-${version}";
  version = "0.14.6";

  goPackagePath = "github.com/gruntwork-io/terragrunt";

  src = fetchFromGitHub {
    owner  = "gruntwork-io";
    repo   = "terragrunt";
    rev    = "v${version}";
    sha256 = "14zg1h76wfg6aa78llcnza7kapnl5ks6m2vg73b90azfi49fmkwz";
  };

  goDeps = ./deps.nix;

  buildInputs = [ makeWrapper ];

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-X main.VERSION=v${version}")
  '';

  postInstall = ''
    wrapProgram $bin/bin/terragrunt \
      --set TERRAGRUNT_TFPATH ${lib.getBin terraform-full}/bin/terraform
  '';

  meta = with stdenv.lib; {
    description = "A thin wrapper for Terraform that supports locking for Terraform state and enforces best practices.";
    homepage = https://github.com/gruntwork-io/terragrunt/;
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
