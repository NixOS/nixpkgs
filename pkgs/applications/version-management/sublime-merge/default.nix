{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
{
  sublime-merge = common {
    buildVersion = "2110";
    aarch64sha256 = "lG95VgRsicSRjve7ESTamU9dp/xBjR6yyLL+1wh6BXg=";
    x64sha256 = "v5CFqS+bB0Oe0fZ+vP0zxrJ2SUctNXKqODmB8M9XMIY=";
  } { };

  sublime-merge-dev = common {
    buildVersion = "2111";
    dev = true;
    aarch64sha256 = "ZDERtZ1NbYdc/rZYfiFPkjwSQVMvacVElRAW/PBrgCg=";
    x64sha256 = "NgHRF8Wh3ktr0Z+efL2FTwFAdF3c0yaXNFEwcvefSy0=";
  } { };
}
