{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "stable";
  version = "2.12.4";
  sha256 = "1nl831xjhxyw1r2zvdxy3455sfn1cnn6970n02q7aalmqgz9rpdd";
  vendorSha256 = "sha256-c7x2vNO6ap5Ecx4+1hKy6PImFuclSQqvkBKr0LPdX4M=";
}
