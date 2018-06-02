{ stdenv, buildGoPackage, fetchFromGitHub, fetchgx }:

buildGoPackage rec {
  name = "ipfs-${version}";
  version = "0.4.15";
  rev = "v${version}";

  goPackagePath = "github.com/ipfs/go-ipfs";

  extraSrcPaths = [
    (fetchgx {
      inherit name src;
      sha256 = "0bysfh2hd040i8lnyzhy96frflls4kdnlw748cl51ngqg3rwbhgz";
    })
  ];

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "go-ipfs";
    inherit rev;
    sha256 = "1ry4a4pq26dbwy2b9cwi3xjaiyq6sng9lxnb1n30zxhp4w7rla2h";
  };

  meta = with stdenv.lib; {
    description = "A global, versioned, peer-to-peer filesystem";
    homepage = https://ipfs.io/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
