{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "ipfs-cluster";
  version = "0.14.5";

  vendorSha256 = "sha256-ykUjq7Svp3+kUNnFkwsBlC+C4nws6Yvu3bk2Wb4c8vY=";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "ipfs-cluster";
    rev = "v${version}";
    sha256 = "sha256-Xb7QbBmCJKgokxvdbtWxtnNIS/iUsYFLlRzgfoABAq8=";
  };

  # Remove patch when updating to >0.14.5
  patches = [
    (fetchpatch {
      name = "remove-distribution-test.patch";
      url = "https://github.com/ipfs/ipfs-cluster/pull/1589/commits/49825d1df76f848806f1d76abce5e279221cc8c5.patch";
      sha256 = "sha256-mM2rc4ai/qhbvxnoRw5jO7BTRlD2/Tp037EuqqS49DE=";
    })
  ];

  meta = with lib; {
    description = "Allocate, replicate, and track Pins across a cluster of IPFS daemons";
    homepage = "https://cluster.ipfs.io/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ Luflosi jglukasik ];
  };
}
