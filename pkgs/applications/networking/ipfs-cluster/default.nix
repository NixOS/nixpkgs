{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "ipfs-cluster";
  version = "1.0.7";

  vendorHash = "sha256-/Kjm/hM+lKsZ6fzStDyOitp7Vtt7Vb8ak7E/W0lbW20=";

  src = fetchFromGitHub {
    owner = "ipfs-cluster";
    repo = "ipfs-cluster";
    rev = "v${version}";
    hash = "sha256-eBbbD77nnjcumhrsixAlI09B1ZAxK5IOHoBeJGgj+TY=";
  };

  meta = with lib; {
    description = "Allocate, replicate, and track Pins across a cluster of IPFS daemons";
    homepage = "https://ipfscluster.io";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi jglukasik ];
  };
}
