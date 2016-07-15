{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "terraform-${version}";
  version = "0.6.16";
  rev = "v${version}";

  goPackagePath = "github.com/hashicorp/terraform";

  src = fetchFromGitHub {
    inherit rev;
    owner = "hashicorp";
    repo = "terraform";
    sha256 = "1bg8hn4b31xphyxrc99bpnf7gmq20fxqx1k871nidx132brcsah2";
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
