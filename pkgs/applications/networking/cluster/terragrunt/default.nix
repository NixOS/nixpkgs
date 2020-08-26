{ stdenv, lib, buildGoModule, fetchFromGitHub, terraform, makeWrapper }:

buildGoModule rec {
  pname = "terragrunt";
  version = "0.23.33";

   src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "0fsyvmdg2llnzy0yzmiihnb865ccq2sn6d3i935dflppnjyp01p4";
  };

  vendorSha256 = "05p72l724qqf61dn0frahf4awvkkcw8cpl6nhwlacd1jw8c14fjl";

  doCheck = false;

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
