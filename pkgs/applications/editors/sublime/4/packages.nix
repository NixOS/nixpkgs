{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
{
  sublime4 = common {
    buildVersion = "4189";
    x64sha256 = "0vEG2FfLK+93UtpYV9iWl187iN79Tozm38Vh6lbzW7A=";
    aarch64sha256 = "ZyLnbvpyxvJfyfu663ED0Yn5M37As+jy6TREZMgSHgI=";
  } { };

  sublime4-dev = common {
    buildVersion = "4187";
    dev = true;
    x64sha256 = "4Xcpnvplj3ik3kWtwJ6ZT//nRgMCw/ceN7bVuEDApDA=";
    aarch64sha256 = "EreN+SjVnm1Kt+Oz72AQ86AKdgm9n72lv/JQvefb8YU=";
  } { };
}
