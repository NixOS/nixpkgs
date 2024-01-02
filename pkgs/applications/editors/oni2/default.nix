{ callPackage }:

let mkOni2 = callPackage ./common.nix { };
in mkOni2 rec {
  variant = "oni2";
  license = {
    fullName = "Outrun Labs End User License Agreement";
    url = "https://github.com/onivim/oni2/blob/master/Outrun-Labs-EULA-v1.1.md";
    free = false;
  };
  version = "0.5.7";
  rev = "v${version}";
  sha256 = "NlN0Ntdwtx5XLjd1ltUzv/bjmJQR5eyRqtmicppP6YU=";
  fetchDepsSha256 = "k7G6jPJfxCCSuSucPfiXljCVJhmjl/BxWMCEjv2tfhA=";
}

