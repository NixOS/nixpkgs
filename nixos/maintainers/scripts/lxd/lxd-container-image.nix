{ lib, pkgs, ... }:

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
  system.activationScripts.config = let
    config = pkgs.substituteAll {
      src = ./lxd-container-image-inner.nix;
      stateVersion = lib.trivial.release;
    };
  in ''
    if [ ! -e /etc/nixos/configuration.nix ]; then
      install -m 644 -D ${config} /etc/nixos/configuration.nix
    fi
  '';

  # Network
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;
}
