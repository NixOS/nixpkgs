{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "terraform-provider-azurerm";
  name = "${pname}-${version}";
  version = "0.1.5";

  goPackagePath = "github.com/terraform-providers/terraform-provider-azurerm";

  src = fetchFromGitHub {
    owner  = "terraform-providers";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "02g8wnzwaii24nx5iin1yd4bx0rx22ly8aqhwa39mr5hsjj1qy4k";
  };
}