{ stdenv, lib, buildGoPackage, fetchFromGitHub, terraform, makeWrapper }:

buildGoPackage rec {
  name = "terragrunt-${version}";
  version = "0.8.0";
  rev = "v${version}";

  goPackagePath = "github.com/gruntwork-io/terragrunt";

  src = fetchFromGitHub {
    inherit rev;
    owner  = "gruntwork-io";
    repo   = "terragrunt";
    sha256 = "1d035p2r6d8c1crxvpi5ayb9jx6f2pdgzw2197zhllavyi8n8dw1";
  };

  goDeps = ./deps.nix;

  buildInputs = [ makeWrapper terraform ];

  postInstall = ''
    wrapProgram $bin/bin/terragrunt \
      --suffix PATH : ${lib.makeBinPath [ terraform ]}
  '';

  meta = with stdenv.lib; {
    description = "A thin wrapper for Terraform that supports locking for Terraform state and enforces best practices.";
    homepage = https://github.com/gruntwork-io/terragrunt/;
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
