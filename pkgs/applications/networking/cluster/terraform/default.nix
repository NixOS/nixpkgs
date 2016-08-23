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
    # remove all plugins, they are part of the main binary now
    for i in $bin/bin/*; do
      if [[ $(basename $i) != terraform ]]; then
        rm "$i"
      fi
    done
  '';
}
