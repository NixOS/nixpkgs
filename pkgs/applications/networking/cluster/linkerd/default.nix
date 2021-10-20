{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "stable";
  version = "2.10.2";
  sha256 = "sha256-dOD0S4FJ2lXE+1VZooi8tKvC8ndGEHAxmAvSqoWI/m0=";
  vendorSha256 = "sha256-Qb0FZOvKL9GgncfUl538PynkYbm3V8Q6lUpApUoIp5s=";
}
