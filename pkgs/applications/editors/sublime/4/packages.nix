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
    buildVersion = "4207";
    dev = true;
    x64sha256 = "q8UVYQhLu18Lh1sLp+1jR4Kx1taDsRUOmHY4km6opJA=";
    aarch64sha256 = "sZwAZCMsvJuCvxpmjn829SxsV0IIuI+SEPjbQJwNO7Q=";
  } { };
}
