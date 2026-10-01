{
  lib,
  stdenv,
  config,
  newScope,
  fetchFromGitHub,
  cudaPackages,
}:
let
  suitesparseVersion = "7.12.2";
in
lib.makeScope newScope (
  self:
  lib.packagesFromDirectoryRecursive {
    inherit (self) callPackage;
    directory = ./by-name;
  }
  // {
    enableCuda = config.cudaSupport;
    stdenv = if self.enableCuda then cudaPackages.backendStdenv else stdenv;
    mkDerivation = self.callPackage ./mk-suitesparse-derivation.nix {
      suitesparseSource = fetchFromGitHub {
        owner = "DrTimothyAldenDavis";
        repo = "SuiteSparse";
        tag = "v${suitesparseVersion}";
        hash = "sha256-reR23aBs3rdNdDYpjuN6XbAmrBZ1euFsKreBdPI//gI=";
      };
    };
  }
)
