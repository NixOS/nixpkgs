{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "distribution";
  version = "2.8.3";
  rev = "v${version}";

  goPackagePath = "github.com/docker/distribution";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "distribution";
    inherit rev;
    sha256 = "sha256-6/clOTkI1JnDjb+crcHmjbQlaqffP/sntGqUB2ftajU=";
  };

  meta = with lib; {
    description = "The Docker toolset to pack, ship, store, and deliver content";
    license = licenses.asl20;
    maintainers = [ maintainers.globin ];
    platforms = platforms.unix;
  };
}
