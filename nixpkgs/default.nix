{ system ? builtins.currentSystem
, config ? {}
, pkgs ? import <nixpkgs> { inherit system config; }
}:

{
  wfs-tools = pkgs.callPackage ./pkgs/tools/filesystems/wfs-tools { };
} 