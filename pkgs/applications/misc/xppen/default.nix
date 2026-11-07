{
  callPackage,
}:

# to update: try to find the latest 3.x.x or 4.x.x .tar.gz on https://www.xp-pen.com/download
{
  xppen_3 = callPackage ./generic.nix {
    pname = "xppen_3";
    version = "3.4.9-240607";
    url = "https://www.xp-pen.com/download/file.html?id=2901&pid=819&ext=gz";
    hash = "sha256-ZXeTlDjhryXamb7x2LxDdOtf8R9rgKPyUsdx96XchWM=";
  };
  xppen_4 = callPackage ./generic.nix {
    pname = "xppen_4";
    version = "4.0.15-260422";
    url = "https://download01.xp-pen.com/file/2026/04/XPPenLinux4.0.15-260422.tar.gz";
    hash = "sha256-vM1Lf2Nh/KqnENIZuhG8HehByv+XIukLtmpPlsIU9x0=";
  };
}
