{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "terraform-provider-kubernetes";
  name = "${pname}-${version}";
  version = "1.0.0";

  goPackagePath = "github.com/terraform-providers/terraform-provider-kubernetes";

  src = fetchFromGitHub {
    owner  = "terraform-providers";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1kh7a83f98v6b4v3zj84ddhrg2hya4nmvrw0mjc26q12g4z2d5g6";
  };
}