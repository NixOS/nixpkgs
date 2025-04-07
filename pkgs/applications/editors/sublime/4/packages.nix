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
    buildVersion = "4196";
    dev = true;
    x64sha256 = "lsvPDqN9YkhDl/4LjLoHkV+Po9lTJpS498awzMMCh3c=";
    aarch64sha256 = "Bwy69jCKkj8AT8WeMXJ3C+yUk+PArHETyp1ZvMXjR5A=";
  } { };
}
