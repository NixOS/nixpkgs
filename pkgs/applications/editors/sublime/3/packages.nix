{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
  rec {
    sublime3-dev = common {
      buildVersion = "3160";
      x32sha256 = "0vib7d6g47pxkr41isarig985l2msgal6ad9b9qx497aa8v031r5";
      x64sha256 = "0dy2w3crb1079w1n3pj37hy4qklvblrl742nrd3n4c7rzmzsg71b";
    } {};

    sublime3 = common {
      buildVersion = "3143";
      x32sha256 = "0dgpx4wij2m77f478p746qadavab172166bghxmj7fb61nvw9v5i";
      x64sha256 = "06b554d2cvpxc976rvh89ix3kqc7klnngvk070xrs8wbyb221qcw";    
    } {};
  }
