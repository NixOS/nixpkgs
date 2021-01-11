{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ipfs-cluster";
  version = "unstable-2020-10-20";

  vendorSha256 = "0abfhl4v4yqy89aqn13ymj4rw5zhr92a9fh1abgpkr19adnyrs3d";

  patches = [
      ./test.patch
  ];

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "ipfs-cluster";
    rev = "c78f7839a2d5645806e01bfbf7af862600f8fbc4";
    sha256 = "0fschpysma2piy2bfas56yapxm2cl6nj986ww3sp7ysldjzadmkk";
  };

  meta = with lib; {
    description = "Allocate, replicate, and track Pins across a cluster of IPFS daemons";
    homepage = "https://cluster.ipfs.io/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jglukasik ];
  };
}
