{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "23.12.4";
  sha256 = "0q6bizch27z1lmw7as7f34zf8b95605wpr27c2mb8s1375q9lixd";
  vendorHash = "sha256-Mp2iZuESfTSe5whejJ7a43WSP6kmxFqoIlDxWx7vBLc=";
}
