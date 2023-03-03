{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "distribution";
  version = "2.8.1";
  rev = "v${version}";

  goPackagePath = "github.com/docker/distribution";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "distribution";
    inherit rev;
    sha256 = "sha256-M8XVeIvD7LtWa9l+6ovwWu5IwFGYt0xDfcIwcU/KH/E=";
  };

  meta = with lib; {
    description = "The Docker toolset to pack, ship, store, and deliver content";
    license = licenses.asl20;
    maintainers = [ maintainers.globin ];
    platforms = platforms.unix;
  };
}
