{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "ipfs-cluster";
  version = "1.0.2";

  vendorSha256 = "sha256-4pCJnQ/X5bvlgyHcRVZ8LyOexaKmz+1xAntMpZCpvd0=";

  src = fetchFromGitHub {
    owner = "ipfs-cluster";
    repo = "ipfs-cluster";
    rev = "v${version}";
    sha256 = "sha256-Mbq4NzMNIGGFOWuHlToGmel/Oa/K6xzpZTVuXnKHq1M=";
  };

  meta = with lib; {
    description = "Allocate, replicate, and track Pins across a cluster of IPFS daemons";
    homepage = "https://ipfscluster.io";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ Luflosi jglukasik ];
  };
}
