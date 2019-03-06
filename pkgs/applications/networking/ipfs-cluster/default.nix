{ stdenv, buildGoPackage, fetchFromGitHub, fetchgx, gx-go }:

buildGoPackage rec {
  name = "ipfs-cluster-${version}";
  version = "0.8.0";
  rev = "v${version}";

  goPackagePath = "github.com/ipfs/ipfs-cluster";

  extraSrcPaths = [
    (fetchgx {
      inherit name src;
      sha256 = "0vqj6h885dy0d3zabris8f5sbqdwm5ljhpf8z466pwm7qx8m5afn";
    })
  ];

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "ipfs-cluster";
    inherit rev;
    sha256 = "0q5j825hzsrlfv3y79376l6pd2d3hiczymw3w9nqh955rphjg7ci";
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

