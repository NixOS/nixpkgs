{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "stable";
  version = "2.14.7";
  sha256 = "0mrnyb98h4614aa3i3ki3gz3rsp60qy038phgmp3x9s0gq11bd23";
  vendorHash = "sha256-bGl8IZppwLDS6cRO4HmflwIOhH3rOhE/9slJATe+onI=";
}
