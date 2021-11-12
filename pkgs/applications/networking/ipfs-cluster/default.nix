{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ipfs-cluster";
  version = "0.14.1";

  vendorSha256 = "sha256-vDNWYgWlM3kJqlHW/6Bj6P+t6M61TvOVRJwDN2p0mi4=";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "ipfs-cluster";
    rev = "v${version}";
    sha256 = "sha256-GELCd12LhA4CBe9DRRBu4r+AwCksaRVIWcSAJScvnbk=";
  };

  meta = with lib; {
    description = "Allocate, replicate, and track Pins across a cluster of IPFS daemons";
    homepage = "https://cluster.ipfs.io/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ Luflosi jglukasik ];
  };
}
