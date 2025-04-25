{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "25.4.4";
  sha256 = "1zdi6ziz8ys231xszzildi1rk0pz15cp27xf7zpy6hl0n2b1vbij";
  vendorHash = "sha256-xr/RMfVYYXtfWpnPmm3tG/TwJITIyRRFzoZwbBQwSc8=";
}
