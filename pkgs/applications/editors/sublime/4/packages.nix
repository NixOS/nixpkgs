{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
{
  sublime4 = common {
    buildVersion = "4192";
    x64sha256 = "3CMorzQj+JFPTXp6PPhX6Mlcz/kJb2FM2iwUsvrhy+s=";
    aarch64sha256 = "gVhDBac3kyDU1qIiXoN7Xf5Jvbdnif2QGuFUy2C34Mo=";
  } { };

  sublime4-dev = common {
    buildVersion = "4188";
    dev = true;
    x64sha256 = "b7JyJ9cPxb/Yjy9fvcz/m6OLETxMd8rwkmrEyMGAjjc=";
    aarch64sha256 = "oGL0UtQge21oH6p6BNsRkxqgvdi9PkT/uwZTYygu+ng=";
  } { };
}
