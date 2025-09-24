{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "25.7.4";
  sha256 = "19s32frf6ymfv88zvinakqh23yp7zlcj6dcyzlkkviayf4gk270x";
  vendorHash = "sha256-6cUWeJA0nxUMd+mrrHccPu9slebwZGUR0yGxev3k4ls=";
}
