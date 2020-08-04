{ stdenv, lib, buildGoModule, fetchFromGitHub, terraform, makeWrapper }:

buildGoModule rec {
  pname = "terragrunt";
  version = "0.23.31";

   src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wpb749hc6pbmxcba1k4yrwcg8547rnsskxb45bzqyqyj1nj775s";
  };

  vendorSha256 = "1xn7c6y32vpanqvf1sfpw6bs73dbjniavjbf00j0vx83bfyklsr4";

  buildInputs = [ makeWrapper ];

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-X main.VERSION=v${version}")
  '';

  postInstall = ''
    wrapProgram $out/bin/terragrunt \
      --set TERRAGRUNT_TFPATH ${lib.getBin terraform.full}/bin/terraform
  '';

  meta = with stdenv.lib; {
    description = "A thin wrapper for Terraform that supports locking for Terraform state and enforces best practices.";
    homepage = "https://github.com/gruntwork-io/terragrunt/";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
