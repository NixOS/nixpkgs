{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
{
  sublime4 = common {
    buildVersion = "4186";
    x64sha256 = "Rw/N2uSsMb6uMvMt9lEzBFSAvAePFTwfX09ARDX1mSs=";
    aarch64sha256 = "6RKaSIDj0zOqjYAGb77q3+sKqmp+VFqcgODyU06ajrc=";
  } { };

  sublime4-dev = common {
    buildVersion = "4187";
    dev = true;
    x64sha256 = "4Xcpnvplj3ik3kWtwJ6ZT//nRgMCw/ceN7bVuEDApDA=";
    aarch64sha256 = "EreN+SjVnm1Kt+Oz72AQ86AKdgm9n72lv/JQvefb8YU=";
  } { };
}
