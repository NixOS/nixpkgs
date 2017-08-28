{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "distribution-${version}";
  version = "2.5.2";
  rev = "v${version}";

  goPackagePath = "github.com/docker/distribution";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "distribution";
    inherit rev;
    sha256 = "03n8fr8n1gnb1ijrly99qrw65lwcymf08is5vgmx4qdnbf5g7mj5";
  };

  meta = with stdenv.lib; {
    description = "The Docker toolset to pack, ship, store, and deliver content";
    license = licenses.asl20;
    maintainers = [ maintainers.globin ];
    platforms = platforms.unix;
  };
}
