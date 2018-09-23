{ stdenv, fetchFromGitHub, buildGoPackage }:
buildGoPackage rec {
  name = "terraform-provider-gandi-${version}";
  version = "0.0.1";

  goPackagePath = "github.com/tiramiseb/terraform-provider-gandi";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "tiramiseb";
    repo = "terraform-provider-gandi";
    sha256 = "1ml5wd8fd87jpa2cid6vl2qnpsyn78qvxj7kvb4azyyk7kg9axhr";
    rev = "bea2bc24b19a1c1e1c47794065e88e96caf649db";
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
