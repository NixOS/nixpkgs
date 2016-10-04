{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "terraform-${version}";
  version = "0.7.4";
  rev = "v${version}";

  goPackagePath = "github.com/hashicorp/terraform";

  src = fetchFromGitHub {
    inherit rev;
    owner = "hashicorp";
    repo = "terraform";
    sha256 = "1mj9kk9awhfv717xf9d8nc35xva8wqhbgls7cbgycg550cc2hf85";
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
