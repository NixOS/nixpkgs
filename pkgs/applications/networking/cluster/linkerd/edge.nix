{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "23.1.2";
  sha256 = "1c8l5zzy5pjilp1a84084g3dgdm0rxkx7hj7lqcn0iihfvhxc1xq";
  vendorSha256 = "sha256-6dOX3SsKjpwC/dEUO2SnVna99lpav7kIEKrMUy4YfhA=";
}
