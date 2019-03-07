{ stdenv, fetchFromGitHub, mkTerraformProvider }:
mkTerraformProvider rec {
  pname = "terraform-provider-gandi";
  version = "1.0.0";

  goPackagePath = "github.com/tiramiseb/terraform-provider-gandi";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "tiramiseb";
    repo = "terraform-provider-gandi";
    rev = "v${version}";
    sha256 = "0byydpqsimvnk11bh9iz8zlxbsmsk65w55pvkp18vjzqrhf4kyfv";
  };

  meta = with stdenv.lib; {
    description = "Terraform provider for the Gandi LiveDNS service.";
    homepage = "https://github.com/tiramiseb/terraform-provider-gandi";
    license = licenses.mpl20;
    maintainers = with maintainers; [ manveru ];
  };
}
