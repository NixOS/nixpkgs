{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "terraform-${version}";
  version = "0.6.15";
  rev = "v${version}";
  
  goPackagePath = "github.com/hashicorp/terraform";

  src = fetchFromGitHub {
    inherit rev;
    owner = "hashicorp";
    repo = "terraform";
    sha256 = "1mf98hagb0yp40g2mbar7aw7hmpq01clnil6y9khvykrb33vy0nb";
  };

  postInstall = ''
    # prefix all the plugins with "terraform-"
    for i in $bin/bin/*; do
      if [[ ! $(basename $i) =~ terraform* ]]; then
        mv -v $i $bin/bin/terraform-$(basename $i);
      fi
    done
  '';
}
