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
    buildVersion = "4199";
    dev = true;
    x64sha256 = "Nrhwv+ox/SW21c8wZtuX9mzHQ+o9ghsI50dU2kDvCX0=";
    aarch64sha256 = "3vCXj53f2Qlt/Ab3hNNng+Y4Ch85Dp0G8srTVBtd6zU=";
  } { };
}
