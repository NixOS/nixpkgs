{ lib, pkgs, ... }:

{
  imports = [ ../../../modules/virtualisation/incus-virtual-machine.nix ];

  virtualisation.lxc.templates.nix = {
    enable = true;
    target = "/etc/nixos/incus.nix";
    template = ./nix.tpl;
    when = [
      "create"
      "copy"
    ];
  };

  # Create a default configuration.nix on first boot so nixos-rebuild works
  # out of the box.
  systemd.services.incus-create-nixos-config =
    let
      configFile = pkgs.replaceVars ./incus-virtual-machine-image-inner.nix {
        stateVersion = lib.trivial.release;
      };
    in
    {
      description = "Create default NixOS configuration for Incus";
      wantedBy = [ "multi-user.target" ];
      unitConfig.ConditionPathExists = "!/etc/nixos/configuration.nix";
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.coreutils}/bin/install -m 0644 -D ${configFile} /etc/nixos/configuration.nix";
      };
    };

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
