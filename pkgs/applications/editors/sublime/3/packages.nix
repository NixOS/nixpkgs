{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
  rec {
    sublime3-dev = common {
      buildVersion = "3161";
      x32sha256 = "0qrm2qmfsj71lr83c8zas2n3xk8hk9k4w8ygnasjhggmyjm3wy0q";
      x64sha256 = "0cgadylm68s2jly10r038q1fvmbzmpc2nvqy86vlyq9avgqbm5pc";
    } {};

    sublime3 = common {
      buildVersion = "3143";
      x32sha256 = "0dgpx4wij2m77f478p746qadavab172166bghxmj7fb61nvw9v5i";
      x64sha256 = "06b554d2cvpxc976rvh89ix3kqc7klnngvk070xrs8wbyb221qcw";    
    } {};
  }
