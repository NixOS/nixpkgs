{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.zerotierone;
in
{
  options.services.zerotierone.enable = mkEnableOption "ZeroTierOne";
  options.services.zerotierone.package = mkOption {
    default = pkgs.zerotierone;
    defaultText = "pkgs.zerotierone";
    type = types.package;
    description = ''
      ZeroTier One package to use.
    '';
  };

  config = mkIf cfg.enable {
    systemd.services.zerotierone = {
      description = "ZeroTierOne";
      path = [ cfg.package ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart =
        ''
        mkdir -p /var/lib/zerotier-one
        chmod 700 /var/lib/zerotier-one
        chown -R root:root /var/lib/zerotier-one
        '';
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/zerotier-one";
        Restart = "always";
        KillMode = "process";
      };
    };

    # ZeroTier does not issue DHCP leases, but some strangers might...
    networking.dhcpcd.denyInterfaces = [ "zt0" ];

    environment.systemPackages = [ cfg.package ];
  };
}
