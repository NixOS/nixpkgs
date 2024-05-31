{ pkgs, ...}:
rec {
  openmesh-core = pkgs.callPackage ./openmesh-core { };
}