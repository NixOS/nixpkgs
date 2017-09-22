{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "distribution-${version}";
  version = "2.6.2";
  rev = "v${version}";

  goPackagePath = "github.com/docker/distribution";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "distribution";
    inherit rev;
    sha256 = "0nj4xd72mik4pj8g065cqb0yjmgpj5ppsqf2k5ibz9f68c39c00b";
  };

  meta = with stdenv.lib; {
    description = "The Docker toolset to pack, ship, store, and deliver content";
    license = licenses.asl20;
    maintainers = [ maintainers.globin ];
    platforms = platforms.unix;
  };
}
