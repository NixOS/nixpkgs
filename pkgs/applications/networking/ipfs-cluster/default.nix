{ stdenv, buildGoPackage, fetchFromGitHub, fetchgx, gx-go }:

buildGoPackage rec {
  name = "ipfs-cluster-${version}";
  version = "0.7.0";
  rev = "v${version}";

  goPackagePath = "github.com/ipfs/ipfs-cluster";

  extraSrcPaths = [
    (fetchgx {
      inherit name src;
      sha256 = "19ljx4q9msrv5wwyd85l01l320lhwgma5z3b756ldgj9fs8p9ph6";
    })
  ];

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "ipfs-cluster";
    inherit rev;
    sha256 = "1zqy4zzi33z16fny1dnhqa8z7czrggvbxdxs750gxzbnd9vqzda1";
  };

  nativeBuildInputs = [ gx-go ];

  preBuild = ''
    # fetchgx stores packages by their ipfs hash
    # this will rewrite github.com/ imports to gx/ipfs/
    cd go/src/${goPackagePath}
    gx-go rewrite
  '';

  meta = with stdenv.lib; {
    description = "Allocate, replicate, and track Pins across a cluster of IPFS daemons";
    homepage = https://cluster.ipfs.io/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jglukasik ];
  };
}

