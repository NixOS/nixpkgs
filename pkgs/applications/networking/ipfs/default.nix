{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "ipfs-${version}";
  version = "0.4.20";
  rev = "v${version}";

  goPackagePath = "github.com/ipfs/go-ipfs";

  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "go-ipfs";
    inherit rev;
    sha256 = "1xnjn4pcgknywfndrp2zwln3v1msaffhhfiym5mdz543rsxav0yp";
  };

  meta = with stdenv.lib; {
    description = "A global, versioned, peer-to-peer filesystem";
    homepage = https://ipfs.io/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
