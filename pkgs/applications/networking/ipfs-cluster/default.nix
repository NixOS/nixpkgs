{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ipfs-cluster";
  version = "0.14.4";

  vendorSha256 = "sha256-4j6aPs17YNXyPIRr5NshAPYIfNM08GlYV13jnGtJzQc=";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "ipfs-cluster";
    rev = "v${version}";
    sha256 = "sha256-82t3sHMKZiV6sYnW72N94qfRZ/aMkavj+hiAyg5viHQ=";
  };

  meta = with lib; {
    description = "Allocate, replicate, and track Pins across a cluster of IPFS daemons";
    homepage = "https://cluster.ipfs.io/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ Luflosi jglukasik ];
  };
}
