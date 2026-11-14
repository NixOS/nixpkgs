{
  callPackage,
}:

# to update: try to find the latest 3.x.x or 4.x.x .tar.gz on https://www.xp-pen.com/download
{
  xppen_3 = callPackage ./generic.nix {
    pname = "xppen_3";
    version = "3.4.9-240607";
    hash = "sha256-ZXeTlDjhryXamb7x2LxDdOtf8R9rgKPyUsdx96XchWM=";
  };
  xppen_4 = callPackage ./generic.nix {
    pname = "xppen_4";
    version = "4.0.15-260422";
    hash = "sha256-vM1Lf2Nh/KqnENIZuhG8HehByv+XIukLtmpPlsIU9x0=";
  };
}
