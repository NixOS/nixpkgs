{ lib, pkgs, ... }:

{
  imports = [ ../../../modules/virtualisation/lxc-container.nix ];

  virtualisation.lxc.templates.nix = {
    enable = true;
    target = "/etc/nixos/incus.nix";
    template = ./nix.tpl;
    when = [
      "create"
      "copy"
    ];
  };

  # copy the config for nixos-rebuild
  system.activationScripts.config =
    let
      config = pkgs.replaceVars ./incus-container-image-inner.nix {
        stateVersion = lib.trivial.release;
      };
    in
    ''
      if [ ! -e /etc/nixos/configuration.nix ]; then
        install -m 0644 -D ${config} /etc/nixos/configuration.nix
      fi
    '';

  networking = {
    dhcpcd.enable = false;
    useDHCP = false;
    useHostResolvConf = false;
  };

  systemd.network = {
    enable = true;
    networks."50-eth0" = {
      matchConfig.Name = "eth0";
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };
}
