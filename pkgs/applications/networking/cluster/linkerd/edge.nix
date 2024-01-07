{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "23.12.2";
  sha256 = "1icra5x0mj02yiy8d7byhs4pzbxnixffwj6gdqxkh9g65d8mpc16";
  vendorHash = "sha256-8QyI8jxAdBTo75hqD3rtZtO71QaIs3VjlXI5xjGXS5w=";
}
