{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
{
  sublime4 = common {
    buildVersion = "4215";
    x64sha256 = "wVP0GNOrJrkOzOjAKoLk6WECXtemX34lBgpUV9Q+iNk=";
    aarch64sha256 = "0xRmWkJy8zVRUDQyNyo0UW27WpoS3OKkcELBlC9m7nk=";
  } { };

  sublime4-dev = common {
    buildVersion = "4212";
    dev = true;
    x64sha256 = "AA6ZsWNXs6J4JXI0tbJPDoAhoN8Jj58jhD0hLnTEFNI=";
    aarch64sha256 = "oz9Y7JgQEQskPF23bw6LfBMi0Rke8DDOok0H4ZD+uS0=";
  } { };
}
