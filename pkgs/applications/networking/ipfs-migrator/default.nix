{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage {
  pname = "ipfs-migrator";
  version = "7";

  goPackagePath = "github.com/ipfs/fs-repo-migrations";

  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "fs-repo-migrations";
    rev = "4e8e0b41d7348646c719d572c678c3d0677e541a";
    sha256 = "1i6izncgc3wgabppglnnrslffvwrv3cazbdhsk4vjfsd66hb4d37";
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
