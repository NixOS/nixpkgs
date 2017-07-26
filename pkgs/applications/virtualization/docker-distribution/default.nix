{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "distribution-${version}";
  version = "2.6.0";
  rev = "v${version}";

  goPackagePath = "github.com/docker/distribution";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "distribution";
    inherit rev;
    sha256 = "1yg2zrikn3vkvkx5mn51p6bfjk840qdkn7ahhhvvcsc8mpigrjc6";
  };

  meta = with stdenv.lib; {
    description = "The Docker toolset to pack, ship, store, and deliver content";
    license = licenses.asl20;
    maintainers = [ maintainers.globin ];
    platforms = platforms.unix;
  };
}
