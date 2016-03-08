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
     ./services
     ./roles
     ./manage
    ];

}
