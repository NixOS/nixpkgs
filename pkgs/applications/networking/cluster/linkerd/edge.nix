{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "22.6.1";
  sha256 = "sha256-YM6d2bWcjoNMEbgXVR79tcklTRqAhzm6SzJU2k+7BNU=";
  vendorSha256 = "sha256-i+AbrzN9d9CGZcGj/D4xnYlamp0iOlq2xcax14/GqEE=";
}
