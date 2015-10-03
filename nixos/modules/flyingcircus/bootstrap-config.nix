{ config, pkgs, modulesPath, ... }:

# This gets placed into /etc/nixos/configuration.nix and needs to reference
# as much as possible from the environmen. This is really just copied initially
# for bootstrapping.
{
  imports = [ "${modulesPath}/flyingcircus/vm-base-profile.nix" ];
}
