{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
{
  sublime-merge = common {
    buildVersion = "2112";
    aarch64sha256 = "XtJ4bAKiCZnBEG1ssXhViuyOsLNdeahHAkWZqqCRmvU=";
    x64sha256 = "rzk3PlGpGXDh3Ig3gKb9WSER6PzPKmp1PJJiD0sGVS4=";
  } { };

  sublime-merge-dev = common {
    buildVersion = "2111";
    dev = true;
    aarch64sha256 = "ZDERtZ1NbYdc/rZYfiFPkjwSQVMvacVElRAW/PBrgCg=";
    x64sha256 = "NgHRF8Wh3ktr0Z+efL2FTwFAdF3c0yaXNFEwcvefSy0=";
  } { };
}
