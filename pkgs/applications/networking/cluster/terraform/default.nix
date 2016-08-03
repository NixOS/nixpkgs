{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "terraform-${version}";
  version = "0.7.0";
  rev = "v${version}";

  goPackagePath = "github.com/hashicorp/terraform";

  src = fetchFromGitHub {
    inherit rev;
    owner = "hashicorp";
    repo = "terraform";
    sha256 = "0k5d6zph6sq1qg8vi5jmk7apy6v67xn5i7rqjamyr5an7lpxssc9";
  };

  postInstall = ''
    # prefix all the plugins with "terraform-"
    for i in $bin/bin/*; do
      if [[ $(basename $i) != terraform ]]; then
        mv -v $i $bin/bin/terraform-$(basename $i);
      fi
    done
  '';
}
