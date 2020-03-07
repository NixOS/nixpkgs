{ stdenv, buildGoPackage, fetchFromGitHub }:

#
# USAGE:
# install the following package globally or in nix-shell:
#
#   (terraform.withPlugins ( plugins: [ terraform-provider-ibm ]))
#
# examples:
# https://github.com/IBM-Cloud/terraform-provider-ibm/tree/master/examples
#

buildGoPackage rec {
  pname = "terraform-provider-ibm";
  version = "0.11.1";

  goPackagePath = "github.com/terraform-providers/terraform-provider-ibm";
  subPackages = [ "./" ];

  src = fetchFromGitHub {
    owner = "IBM-Cloud";
    repo = "terraform-provider-ibm";
    sha256 = "1vp1kzadfkacn6c4illxjra8yki1fx7h77b38fixkcvc79mzasmv";
    rev = "v${version}";
  };

  # Terraform allow checking the provider versions, but this breaks
  # if the versions are not provided via file paths.
  postBuild = "mv go/bin/terraform-provider-ibm{,_v${version}}";

  meta = with stdenv.lib; {
    homepage = https://github.com/IBM-Cloud/terraform-provider-ibm;
    description = "Terraform provider is used to manage IBM Cloud resources.";
    platforms = platforms.all;
    license = licenses.mpl20;
    maintainers = with maintainers; [ jensbin ];
  };
}
