{ stdenv, buildGoPackage, fetchFromGitHub}:

buildGoPackage rec {
  name = "terraform-inventory-${version}";
  version = "0.7-pre";
  rev = "v${version}";

  goPackagePath = "github.com/adammck/terraform-inventory";

  subPackages = [ "./" ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "adammck";
    repo = "terraform-inventory";
    sha256 = "0wwyi2nfyn3wfpmvj8aabn0cjba0lpr5nw3rgd6qdywy7sc3rmb1";
  };

  goDeps = ./deps.nix;

  meta = {
    homepage = https://github.com/adammck/terraform-inventory;
    description = "Terraform state to ansible inventory adapter";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.mit;
  };
}
