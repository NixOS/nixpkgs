{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "terraform-${version}";
  version = "0.9.0";

  goPackagePath = "github.com/hashicorp/terraform";

  src = fetchFromGitHub {
    owner  = "hashicorp";
    repo   = "terraform";
    rev    = "v${version}";
    sha256 = "1v96qgc6pd1bkwvkz855625xdcy7xb5lk60lg70144idqmwfjb9g";
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
    maintainers = with maintainers; [
      jgeerds
      zimbatm
    ];
  };
}
