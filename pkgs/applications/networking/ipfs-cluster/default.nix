{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "ipfs-cluster";
  version = "1.0.0";

  vendorSha256 = "sha256-b0k1V1+JikGemSQjyiKcH7cgyDEt0Nn5aVUf6nnE+/0=";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "ipfs-cluster";
    rev = "v${version}";
    sha256 = "sha256-vwu+Fj7PegbK9pmnsNuEl/AQz2gejRiFAAAov5+VNMQ=";
  };

  meta = with lib; {
    description = "Allocate, replicate, and track Pins across a cluster of IPFS daemons";
    homepage = "https://cluster.ipfs.io/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ Luflosi jglukasik ];
  };
}
