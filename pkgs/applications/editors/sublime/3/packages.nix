{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
  rec {
    sublime3-dev = common {
      buildVersion = "3162";
      x32sha256 = "190il02hqvv64w17w7xc1fz2wkbhk5a5y96jb25dvafmslm46d4i";
      x64sha256 = "1nsjhjs6zajhx7m3dk7i450krg6pb03zffm1n3m1v0xb9zr37xz3";
    } {};

    sublime3 = common {
      buildVersion = "3143";
      x32sha256 = "0dgpx4wij2m77f478p746qadavab172166bghxmj7fb61nvw9v5i";
      x64sha256 = "06b554d2cvpxc976rvh89ix3kqc7klnngvk070xrs8wbyb221qcw";
    } {};
  }
