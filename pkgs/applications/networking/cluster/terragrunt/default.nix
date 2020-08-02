{ stdenv, lib, buildGoModule, fetchFromGitHub, terraform, makeWrapper }:

buildGoModule rec {
  pname = "terragrunt";
  version = "0.23.32";

   src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pa3k0hjdb5bj0bp4aj3lfcgz98l3wd9kfa12rn9zzbcmp087kih";
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
