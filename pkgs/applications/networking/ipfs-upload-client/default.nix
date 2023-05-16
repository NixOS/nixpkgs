{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ipfs-upload-client";
<<<<<<< HEAD
  version = "0.1.2";
=======
  version = "0.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "infura";
    repo = "ipfs-upload-client";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-BT/LC+PKzAjxM7P2Iis28OlJmrZRbCwfd6kPEL3oaaI=";
  };

  vendorHash = "sha256-YzIUoN/B4TBlAfmvORrR9Gy+lMzwlaePm8yBoMsPaYU=";
=======
    sha256 = "sha256-O9N2QGQDNk/nwpuJrJKy9arN3gjsBAL+IdghfSaUrCw=";
  };

  vendorSha256 = "sha256-YzIUoN/B4TBlAfmvORrR9Gy+lMzwlaePm8yBoMsPaYU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A minimal CLI tool to upload files and directories to IPFS via Infura's IPFS or another API endpoint";
    homepage = "https://github.com/INFURA/ipfs-upload-client";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
