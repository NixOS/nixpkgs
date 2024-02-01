{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "24.1.2";
  sha256 = "1rwdjlf20k84g94ca724wcpykpd9z0q8ymi0mdyz86kfry6hr5sz";
  vendorHash = "sha256-8fNse2ZuyWqZsHSUh+buEIYPf8JsEL+0Z8tkbxfiCwA=";
}
