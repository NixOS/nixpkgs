# Ideally, this file would have been placed in
# pkgs/by-name/ss/sshd-openpgp-auth/package.nix, but since `./generic.nix` is
# outside of the directory, the `nixpkgs-vet` test will fail the CI. So
# we call this file in all-packages.nix like in the old days.
{ callPackage }:

callPackage ./generic.nix {
  pname = "sshd-openpgp-auth";
  version = "0.3.1";
  srcHash = "sha256-YS8/q8faWSRNciR03wwiiGGgkvZqb5Euto22pde53C8=";
  cargoHash = "sha256-rBkKQAq1IAc4udS65RvprQe6knxyAFKxCWKGW5k5te4=";
  metaDescription = "Command-line tool for creating and managing OpenPGP based trust anchors for SSH host keys";
}
