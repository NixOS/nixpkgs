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
    buildVersion = "4196";
    dev = true;
    x64sha256 = "lsvPDqN9YkhDl/4LjLoHkV+Po9lTJpS498awzMMCh3c=";
    aarch64sha256 = "Bwy69jCKkj8AT8WeMXJ3C+yUk+PArHETyp1ZvMXjR5A=";
  } { };
}
