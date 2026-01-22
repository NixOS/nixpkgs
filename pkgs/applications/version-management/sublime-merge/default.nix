{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
{
  sublime-merge = common {
    buildVersion = "2121";
    aarch64sha256 = "WAT2gmAg63cu3FJIw5D3rRa+SNonymfsLaTY8ALa1ec=";
    x64sha256 = "yWrrlDe5C90EMQVdpENWnGURcVEdxJlFkalEfPpztzQ=";
  } { };

  sublime-merge-dev = common {
    buildVersion = "2111";
    dev = true;
    aarch64sha256 = "ZDERtZ1NbYdc/rZYfiFPkjwSQVMvacVElRAW/PBrgCg=";
    x64sha256 = "NgHRF8Wh3ktr0Z+efL2FTwFAdF3c0yaXNFEwcvefSy0=";
  } { };
}
