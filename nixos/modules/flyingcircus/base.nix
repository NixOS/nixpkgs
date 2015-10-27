{ config, lib, pkgs, ... }:
# Configuration for FCIO style machines, independent of the infrastructure:
# applies to Vagrant, FC-owned infrastructure, ...

with lib;

{

  nix.binaryCachePublicKeys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "flyingcircus.io-1:Rr9CwiPv8cdVf3EQu633IOTb6iJKnWbVfCC8x8gVz2o="
  ];

}
