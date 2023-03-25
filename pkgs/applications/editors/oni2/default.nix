{ callPackage }:

let mkOni2 = callPackage ./common.nix { };
in mkOni2 rec {
  variant = "oni2";
  license = {
    fullName = "MIT";
    url = "https://github.com/onivim/oni2/blob/master/LICENSE.md";
    free = true;
  };
  version = "0.5.7";
  rev = "v${version}";
  sha256 = "NlN0Ntdwtx5XLjd1ltUzv/bjmJQR5eyRqtmicppP6YU=";
  fetchDepsSha256 = "k7G6jPJfxCCSuSucPfiXljCVJhmjl/BxWMCEjv2tfhA=";
}

