{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "terraform-provider-google";
  name = "${pname}-${version}";
  version = "0.1.3";

  goPackagePath = "github.com/terraform-providers/terraform-provider-google";

  src = fetchFromGitHub {
    owner  = "terraform-providers";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1aa1hz0yc4g746m6dl04hc70rcrzx0py8kpdch3kim475bspclnf";
  };
}