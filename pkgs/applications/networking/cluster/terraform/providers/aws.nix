{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "terraform-provider-aws";
  name = "${pname}-${version}";
  version = "0.1.4";

  goPackagePath = "github.com/terraform-providers/terraform-provider-aws";

  src = fetchFromGitHub {
    owner  = "terraform-providers";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "0hqyvp1bgyfqq2lkjq5m5qxybagnxl9zrqiqfnlrfigdp0y31iz8";
  };
}