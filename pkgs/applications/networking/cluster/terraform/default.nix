{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "terraform-${version}";
  version = "0.7.2";
  rev = "v${version}";

  goPackagePath = "github.com/hashicorp/terraform";

  src = fetchFromGitHub {
    inherit rev;
    owner = "hashicorp";
    repo = "terraform";
    sha256 = "002jg4iwg4g4hkg4hm3szlkyagqzipln3l44b8azh1a7vh1m8cp2";
  };

  postInstall = ''
    # remove all plugins, they are part of the main binary now
    for i in $bin/bin/*; do
      if [[ $(basename $i) != terraform ]]; then
        rm "$i"
      fi
    done
  '';

  meta = with stdenv.lib; {
    description = "Tool for building, changing, and versioning infrastructure";
    homepage = "https://www.terraform.io/";
    license = licenses.mpl20;
  };
}
