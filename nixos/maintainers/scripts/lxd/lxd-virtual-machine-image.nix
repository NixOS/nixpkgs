{ lib, pkgs, ... }:

{
  imports = [
    ../../../modules/virtualisation/lxd-virtual-machine.nix
  ];

  virtualisation.lxc.templates.nix = {
    enable = true;
    target = "/etc/nixos/lxd.nix";
    template = ./nix.tpl;
    when = [
      "create"
      "copy"
    ];
  };

  # copy the config for nixos-rebuild
  system.activationScripts.config =
    let
      config = pkgs.substituteAll {
        src = ./lxd-virtual-machine-image-inner.nix;
        stateVersion = lib.trivial.release;
      };
    in
    ''
      if [ ! -e /etc/nixos/configuration.nix ]; then
        install -m 0644 -D ${config} /etc/nixos/configuration.nix
      fi
    '';

  # Network
  networking = {
    dhcpcd.enable = false;
    useDHCP = false;
    useHostResolvConf = false;
  };

  systemd.network = {
    enable = true;
    networks."50-enp5s0" = {
      matchConfig.Name = "enp5s0";
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };
}
