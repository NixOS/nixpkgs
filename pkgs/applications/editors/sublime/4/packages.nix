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
    buildVersion = "4205";
    dev = true;
    x64sha256 = "1Tg8m4FNrVOeHK6VSmlua30pW4Bu7Gz+sT0t/w01UyM=";
    aarch64sha256 = "K94UipUVZRh8xJKYW35be0u9L/VHpZ+FYhC26v41b3U=";
  } { };
}
