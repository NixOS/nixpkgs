{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ipfs-upload-client";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "infura";
    repo = "ipfs-upload-client";
    rev = "v${version}";
    hash = "sha256-BT/LC+PKzAjxM7P2Iis28OlJmrZRbCwfd6kPEL3oaaI=";
  };

  vendorHash = "sha256-YzIUoN/B4TBlAfmvORrR9Gy+lMzwlaePm8yBoMsPaYU=";

  meta = with lib; {
    description = "A minimal CLI tool to upload files and directories to IPFS via Infura's IPFS or another API endpoint";
    homepage = "https://github.com/INFURA/ipfs-upload-client";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
