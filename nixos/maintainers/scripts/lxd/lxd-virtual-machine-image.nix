{ lib, pkgs, ... }:

{
  imports = [
    ../../../modules/virtualisation/lxd-virtual-machine.nix
  ];

  virtualisation.lxc.templates.nix = {
    enable = true;
    target = "/etc/nixos/lxd.nix";
    template = ./nix.tpl;
    when = ["create" "copy"];
  };

  # copy the config for nixos-rebuild
  system.activationScripts.config = let
    config = pkgs.substituteAll {
      src = ./lxd-virtual-machine-image-inner.nix;
      stateVersion = lib.trivial.release;
    };
  in ''
    if [ ! -e /etc/nixos/configuration.nix ]; then
      mkdir -p /etc/nixos
      cp ${config} /etc/nixos/configuration.nix
    fi
  '';

  # Network
  networking.useDHCP = false;
  networking.interfaces.enp5s0.useDHCP = true;
}
