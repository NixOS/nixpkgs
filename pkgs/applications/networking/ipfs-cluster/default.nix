{ stdenv, buildGoPackage, fetchFromGitHub, fetchgx, gx-go }:

buildGoPackage rec {
  name = "ipfs-cluster-${version}";
  version = "0.5.0";
  rev = "v${version}";

  goPackagePath = "github.com/ipfs/ipfs-cluster";

  extraSrcPaths = [
    (fetchgx {
      inherit name src;
      sha256 = "0jwz3kd07i5fs0sxds80j8d338skhgxgxra377qxsk0cr2hhj2vm";
    })
  ];

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "ipfs-cluster";
    inherit rev;
    sha256 = "132whjyplcifq8747hcdrgbc0amhp618dg049jq5nyslcxfgdypm";
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

