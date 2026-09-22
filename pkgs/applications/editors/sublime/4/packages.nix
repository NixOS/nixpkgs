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
    buildVersion = "4212";
    dev = true;
    x64sha256 = "AA6ZsWNXs6J4JXI0tbJPDoAhoN8Jj58jhD0hLnTEFNI=";
    aarch64sha256 = "oz9Y7JgQEQskPF23bw6LfBMi0Rke8DDOok0H4ZD+uS0=";
  } { };
}
