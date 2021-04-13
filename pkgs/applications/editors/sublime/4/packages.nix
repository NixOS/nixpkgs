{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
  {
    sublime4-dev = common {
      buildVersion = "4102";
      dev = true;
      x64sha256 = "1xbrh90aa785fg46iqhpxl87kxqlkfj467a8y93z4ydkhf80nwi9";
      aarch64sha256 = "00km0fddlfjd7wbz0ci4fjd42aibfpdgxgaahs2bnknsza4nfhbq";
    } {};
  }
