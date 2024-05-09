# Ideally, this file would have been placed in
# pkgs/by-name/ss/sshd-openpgp-auth/package.nix, but since `./generic.nix` is
# outside of the directory, the nixpkgs-check-by-name test will fail the CI. So
# we call this file in all-packages.nix like in the old days.
{ callPackage }:

callPackage ./generic.nix {
  pname = "sshd-openpgp-auth";
  version = "0.3.0";
  srcHash = "sha256-IV0Nhdqyn12HDOp1jaKz3sKTI3ktFd5b6qybCLWt27I=";
  cargoHash = "sha256-/+lZkVMeFUMRD7NQ/MHDU5f3rkKDx1kDv5tjA41RExc=";
  metaDescription =
    "Command-line tool for creating and managing OpenPGP based trust anchors for SSH host keys";
}
