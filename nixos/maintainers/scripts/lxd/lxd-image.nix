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
      sed 's|../../../modules/virtualisation/lxc-container.nix|<nixpkgs/nixos/modules/virtualisation/lxc-container.nix>|g' -i /etc/nixos/configuration.nix
    fi
  '';

  # Network
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;

  # As this is intended as a standalone image, undo some of the minimal profile stuff
  documentation.enable = true;
  documentation.nixos.enable = true;
  environment.noXlibs = false;
}
