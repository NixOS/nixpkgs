{ callPackage, ... }:

callPackage ./generic.nix {
  version = "5.2.14";
  kde-channel = "stable";
  hash = "sha256-VWkAcmwv8U5g97rB6OkVAQDyzZJmnKXcdKxYUe+sKIc=";
}
