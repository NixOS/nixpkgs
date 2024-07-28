{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "24.7.5";
  sha256 = "03hsz87vpysw4y45afsbr3amkrqnank1zcclfh6qj0yf98ymxxbn";
  vendorHash = "sha256-0NKoQICbKM3UA62LNySqu5pS2bPuuEfmOEukxB/6Ges=";
}
