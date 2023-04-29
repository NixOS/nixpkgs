{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.openvpn3;
in
{
  options.programs.openvpn3 = {
    enable = mkEnableOption (mdDoc "the openvpn3 client");

    package = mkOption {
      default = pkgs.openvpn3;
      defaultText = literalExpression "pkgs.openvpn3";
      type = types.package;
      description = mdDoc "The openvpn3 package.";
    };
  };

  config = mkIf cfg.enable {
    services.dbus.packages = with pkgs; [
      openvpn3
    ];

    users.users.openvpn = {
      isSystemUser = true;
      uid = config.ids.uids.openvpn;
      group = "openvpn";
    };

    users.groups.openvpn = {
      gid = config.ids.gids.openvpn;
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/openvpn3 0750 openvpn openvpn - -"
    ];

    systemd.services.openvpn3-netcfg-setup = {
      description = "Generate openvpn3 configuration";
      wantedBy = [ "multi-user.target" ];

      serviceConfig.Type = "oneshot";
      script = ''
        ${cfg.package}/bin/openvpn3-admin init-config --write-configs
        ${if config.services.resolved.enable
        then ''
          ${cfg.package}/bin/openvpn3-admin netcfg-service --config-unset resolv-conf
          ${cfg.package}/bin/openvpn3-admin netcfg-service --config-set systemd-resolved yes
        ''
        else ''
          ${cfg.package}/bin/openvpn3-admin netcfg-service --config-unset systemd-resolved
          ${cfg.package}/bin/openvpn3-admin netcfg-service --config-set resolv-conf /etc/resolv.conf
        ''}
        service="$(busctl status net.openvpn.v3.netcfg | grep Unit=dbus | cut -d= -f2)"
        systemctl restart "$service"
      '';
    };

    environment.systemPackages = with pkgs; [
      openvpn3
    ];
  };

}
