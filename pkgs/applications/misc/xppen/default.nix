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
    version = "4.0.7-250117";
    url = "https://www.xp-pen.com/download/file.html?id=3652&pid=1211&ext=gz";
    hash = "sha256-sH05Qquo2u0npSlv8Par/mn1w/ESO9g42CCGwBauHhU=";
  };
}
