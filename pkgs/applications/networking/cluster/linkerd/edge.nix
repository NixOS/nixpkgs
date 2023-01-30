{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "23.1.1";
  sha256 = "159myaz0zh0j8vdknxshyvkl1khxbznvls2mk5wyssxqll8b3j32";
  vendorSha256 = "sha256-7+ppFmM+NVnMU6pg2FcaSGqcq429EmrPYgAZfHANtEg=";
}
