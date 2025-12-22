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
    buildVersion = "2120";
    dev = true;
    aarch64sha256 = "3JKxLke1l7l+fxhIJWbXbMHK5wPgjZTEWcZd9IvrdPM=";
    x64sha256 = "N8lhSmQnj+Ee1A2eIOkhdhQnHBK3B6vFA3vrPAbYtaI=";
  } { };
}
