{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "ipfs-migrator-${version}";
  version = "6";

  goPackagePath = "github.com/ipfs/fs-repo-migrations";

  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "fs-repo-migrations";
    rev = "a89e9769b9cac25ad9ca31c7e9a4445c7966d35b";
    sha256 = "0x4mbkx7wlqjmkg6852hljq947v9y9k3hjd5yfj7kka1hpvxd7bn";
  };

  patches = [ ./lru-repo-path-fix.patch ];

  meta = with stdenv.lib; {
    description = "Migration tool for ipfs repositories";
    homepage = https://ipfs.io/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ elitak ];
  };
}
