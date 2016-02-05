# This is the placeholder file that gets referenced from
# /etc/nixos/configuration.nix (instead of a symlink.)
#
# It bootstraps the necessary configuration depending on the infrastructure.

{ config, lib, pkgs, ... }:

with lib;

let
    infrastructure_modules =
      if builtins.pathExists /etc/nixos/vagrant.nix
      then [ ./infrastructure/vagrant ]
      else [ ./infrastructure/fcio ];

in
{

  imports =
    infrastructure_modules ++
    [./data
     ./platform
     ./packages
     ./roles
     ./manage
    ];

}
