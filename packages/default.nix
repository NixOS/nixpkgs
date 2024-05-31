{ pkgs, ...}:

rec {
  openmesh-core = pkgs.callPackage ./openmesh-core { };
  xnode-admin = pkgs.callPackage ./xnode-admin { };
}