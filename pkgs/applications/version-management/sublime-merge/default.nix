{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
{
  sublime-merge = common {
    buildVersion = "2102";
    aarch64sha256 = "E//XrWlfvMeRWYfBXVTSSUPlDFY/rzSynJ4aP1WyZ0Y=";
    x64sha256 = "Odb3ZvJCo4HTvJ7z31J/5wlyhSUpZRFBXP3f/Wkb7tU=";
  } { };

  sublime-merge-dev = common {
    buildVersion = "2105";
    dev = true;
    aarch64sha256 = "PpiY2nD4fexo9zmKeHQ9KYnzB8sWkVa4YqO2q3C/abE=";
    x64sha256 = "sUyI6ukNZjvszuKDL5fKvIpf3llZn+qQRg7WSdjw4rs=";
  } { };
}
