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
    buildVersion = "2116";
    dev = true;
    aarch64sha256 = "gjuZ+BBthltxeI6ynSMBMv+lljCSh4eLX4Fp0WdjY6w=";
    x64sha256 = "sjkom46d0732nrr5RV3FVrdO/HJjlEg/ffQJ0muAKkk=";
  } { };
}
