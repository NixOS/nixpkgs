{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "24.2.2";
  sha256 = "1q6lgmasqa9z7hi0ajcjwj24wrqs74v9vy247hq40y5naaqj07j8";
  vendorHash = "sha256-ImICopQkBLvSyy/KPmnd4JYeVIPlbzIUFAY4g2iqICI=";
}
