{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "terraform-provider-template";
  name = "${pname}-${version}";
  version = "0.1.1";

  goPackagePath = "github.com/terraform-providers/terraform-provider-template";

  src = fetchFromGitHub {
    owner  = "terraform-providers";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1qrslnkvcj18jzxmsbf72gm54s8dnw5k5z15nffwgy09vv7mzpcn";
  };
}