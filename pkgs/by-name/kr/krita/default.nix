{ callPackage, ... }:

callPackage ./generic.nix {
  version = "5.2.15";
  kde-channel = "stable";
  hash = "sha256-m5T4Qh2XZ8KU3vWY+xBwfd5usje67KJZBmn7DUuQOzk=";
}
