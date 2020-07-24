{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "distribution";
  version = "2.7.1";
  rev = "v${version}";

  goPackagePath = "github.com/docker/distribution";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "distribution";
    inherit rev;
    sha256 = "1nx8b5a68rn81alp8wkkw6qd5v32mgf0fk23mxm60zdf63qk1nzw";
  };

  meta = with stdenv.lib; {
    description = "The Docker toolset to pack, ship, store, and deliver content";
    license = licenses.asl20;
    maintainers = [ maintainers.globin ];
    platforms = platforms.unix;
  };
}
