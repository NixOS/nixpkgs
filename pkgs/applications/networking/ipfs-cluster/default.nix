{ stdenv, buildGoPackage, fetchFromGitHub, fetchgx, gx-go }:

buildGoPackage rec {
  pname = "ipfs-cluster";
  version = "0.9.0";
  rev = "v${version}";

  goPackagePath = "github.com/ipfs/ipfs-cluster";

  extraSrcPaths = [
    (fetchgx {
      inherit  src;name = "${pname}-${version}";
      sha256 = "1k7xcirvi07p5g9gr9jcx5h39wk7jxfsyjrn5yraa8xdqhn6b6nx";
    })
  ];

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "ipfs-cluster";
    inherit rev;
    sha256 = "1bxwcp0355f1ykjcidbxv218zp9d20nma7lnpn9xcjqc8vaq03kn";
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

