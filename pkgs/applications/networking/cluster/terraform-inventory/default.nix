{ lib, buildGoPackage, fetchFromGitHub}:

buildGoPackage rec {
  pname = "terraform-inventory";
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

  meta = with lib; {
    homepage = "https://github.com/adammck/terraform-inventory";
    description = "Terraform state to ansible inventory adapter";
    license = licenses.mit;
    maintainers = with maintainers; [ htr ];
  };
}
