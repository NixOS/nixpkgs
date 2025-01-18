{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "24.11.8";
  sha256 = "126p7x4yzkkvq2y1sdpfm0g9dv4pinqb0vs5jjg555baw3whxgv9";
  vendorHash = "sha256-fRSPU8Gqoa/F4RTroxvs2lJfRxUG9NOEyqiLmhLuQm4=";
}
