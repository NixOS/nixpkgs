{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "distribution-${version}";
  version = "2.5.1";
  rev = "v${version}";

  goPackagePath = "github.com/docker/distribution";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "distribution";
    inherit rev;
    sha256 = "08nxcsl9bc3k9gav2mkqccm5byrlfcgy6qaqaywiyza0b0cn4kdc";
  };

  meta = with stdenv.lib; {
    description = "The Docker toolset to pack, ship, store, and deliver content";
    license = licenses.asl20;
    maintainers = [ maintainers.globin ];
    platforms = platforms.unix;
  };
}
