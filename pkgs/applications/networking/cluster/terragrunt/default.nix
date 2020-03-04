{ stdenv, lib, buildGoPackage, fetchFromGitHub, terraform, makeWrapper }:

buildGoPackage rec {
  pname = "terragrunt";
  version = "0.21.11";

  goPackagePath = "github.com/gruntwork-io/terragrunt";

  src = fetchFromGitHub {
    owner  = "gruntwork-io";
    repo   = "terragrunt";
    rev    = "v${version}";
    sha256 = "1w64skk67i0sxjd2mkyqh3nglc32wc7schk7h8fwszpa1rw4dfcn";
  };

  goDeps = ./deps.nix;

  buildInputs = [ makeWrapper ];

  preBuild = ''
    find go/src -name vendor | xargs -I % sh -c 'echo Removing %; rm -rf %'
    buildFlagsArray+=("-ldflags" "-X main.VERSION=v${version}")
  '';

  postInstall = ''
    wrapProgram $bin/bin/terragrunt \
      --set TERRAGRUNT_TFPATH ${lib.getBin terraform.full}/bin/terraform
  '';

  meta = with stdenv.lib; {
    description = "A thin wrapper for Terraform that supports locking for Terraform state and enforces best practices.";
    homepage = https://github.com/gruntwork-io/terragrunt/;
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
