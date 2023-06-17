{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "distribution";
  version = "2.8.2";
  rev = "v${version}";

  goPackagePath = "github.com/docker/distribution";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "distribution";
    inherit rev;
    sha256 = "sha256-aBAUyM+MtRZAA6Jxu4cFyRIo5OU+7IdLKdQqgm0AFPI=";
  };

  meta = with lib; {
    description = "The Docker toolset to pack, ship, store, and deliver content";
    license = licenses.asl20;
    maintainers = [ maintainers.globin ];
    platforms = platforms.unix;
  };
}
