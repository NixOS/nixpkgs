{ stdenv, fetchFromGitHub, buildGoPackage }:
buildGoPackage rec {
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

  # Terraform allow checking the provider versions, but this breaks
  # if the versions are not provided via file paths.
  postBuild = "mv go/bin/terraform-provider-gandi{,_v${version}}";

  meta = with stdenv.lib; {
    description = "Terraform provider for the Gandi LiveDNS service.";
    homepage = "https://github.com/tiramiseb/terraform-provider-gandi";
    license = licenses.mpl20;
    maintainers = with maintainers; [ manveru ];
  };
}
