{ lib, config, pkgs, ... }:

with lib;

{
  imports = [
    ../../../modules/virtualisation/lxc-container.nix
  ];

  virtualisation.lxc.templates.nix = {
    enable = true;
    target = "/etc/nixos/lxd.nix";
    template = ./nix.tpl;
    when = [ "create" "copy" ];
  };

  # copy the config for nixos-rebuild
  system.activationScripts.config = ''
    if [ ! -e /etc/nixos/configuration.nix ]; then
      mkdir -p /etc/nixos
      cat ${./lxd-image-inner.nix} > /etc/nixos/configuration.nix
    fi
  '';

  # Make lxc exec work properly
  system.activationScripts.bash = ''
    mkdir -p /bin
    ln -sf /run/current-system/sw/bin/bash /bin/bash
  '';

  # Network
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;
}
