{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "stable";
  version = "2.11.0";
  sha256 = "172in8vmr7c5sff111rrd5127lz2pv7bbh7p399xafnk8ri0fx2i";
  vendorSha256 = "sha256-c3EyVrblqtFuoP7+YdbyPN0DdN6TcQ5DTtFQ/frKM0Q=";
}
