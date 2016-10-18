{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "terraform-${version}";
  version = "0.7.6";
  rev = "v${version}";

  goPackagePath = "github.com/hashicorp/terraform";

  src = fetchFromGitHub {
    inherit rev;
    owner = "hashicorp";
    repo = "terraform";
    sha256 = "02k3g38jk2dm70dkfl4w6is563m4abqvip5srv8bhv7xcgj0nfkq";
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
    maintainers = with maintainers; [ zimbatm ];
  };
}
