{ lib, fetchFromGitHub, buildGoModule }:
buildGoModule rec {
  pname = "terraform-provider-gandi";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "go-gandi";
    repo = "terraform-provider-gandi";
    rev = "v${version}";
    sha256 = "sha256-PI7cujatzmljyxosGMaqg3Jizee9Py7ffq9gKdehlvo=";
  };

  vendorSha256 = "sha256-dASIvZ3d7xTYMfvqeTcSJt+kaswGNRNqjHDcgoRVxNk=";
  deleteVendor = true;

  doCheck = false;

  subPackages = [ "." ];

  # Terraform allow checking the provider versions, but this breaks
  # if the versions are not provided via file paths.
  postBuild = "mv $NIX_BUILD_TOP/go/bin/terraform-provider-gandi{,_v${version}}";

  meta = with lib; {
    description = "Terraform provider for the Gandi LiveDNS service.";
    homepage = "https://github.com/tiramiseb/terraform-provider-gandi";
    license = licenses.mpl20;
    maintainers = with maintainers; [ manveru ];
  };
}
