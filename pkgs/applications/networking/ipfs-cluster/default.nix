{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "ipfs-cluster";
  version = "1.0.4";

  vendorSha256 = "sha256-krjTtH8C1SGhaKMCtsbA2S9ognImof6mwD+vJ/qbyrM=";

  src = fetchFromGitHub {
    owner = "ipfs-cluster";
    repo = "ipfs-cluster";
    rev = "v${version}";
    sha256 = "sha256-LdcCGUbrS6te03y8R7XJJOcG1j6uU0v8uEMeUHLeidg=";
  };

  meta = with lib; {
    description = "Allocate, replicate, and track Pins across a cluster of IPFS daemons";
    homepage = "https://ipfscluster.io";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ Luflosi jglukasik ];
  };
}
