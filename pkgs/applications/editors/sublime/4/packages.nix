{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
{
  sublime4 = common {
    buildVersion = "4200";
    x64sha256 = "NvacVRrRjuRgAr5NnFI/5UXZO2f+pnvupzHnJARLRp8=";
    aarch64sha256 = "z0tqp06ioqqwLhRFmc+eSkI8u5VDwiH32hCVqVSVVmo=";
  } { };

  sublime4-dev = common {
    buildVersion = "4206";
    dev = true;
    x64sha256 = "WZ+MfKnOYTTfVbyW2QRstkAOhAxEv4nXsxsQnnAeA6I=";
    aarch64sha256 = "opMVWTGsPQSb/SpN4Cz9CC8jL42BaqO/da6uC++6t3o=";
  } { };
}
