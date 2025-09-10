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
    buildVersion = "2109";
    dev = true;
    aarch64sha256 = "kkXt+CdmU2C6VJHKvp5M4VzzxhhgSqeFVyORWMQnVTc=";
    x64sha256 = "O1pY4M98mfBY8VaOYYOTRCNTNeUQYmHlB0h1A0GTpe8=";
  } { };
}
