{ config, lib, pkgs, ...}:
let
  cfg = config.services.varnish;

in
with lib;
{
  options = {
    services.varnish = {
      enable = mkOption {
        default = false;
        description = "
          Enable the Varnish Server.
        ";
      };

      http_address = mkOption {
        default = "*:6081";
        description = "
          HTTP listen address and port.
        ";
      };

      config = mkOption {
        description = "
          Verbatim default.vcl configuration.
        ";
      };

      stateDir = mkOption {
        default = "/var/spool/varnish/${config.networking.hostName}";
        description = "
          Directory holding all state for Varnish to run.
        ";
      };
    };

  };

  config = mkIf cfg.enable {

    systemd.services.varnish = {
      description = "Varnish";
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -p ${cfg.stateDir}
        chown -R varnish:varnish ${cfg.stateDir}
      '';
      postStop = ''
        rm -rf ${cfg.stateDir}
      '';
      serviceConfig.ExecStart = "${pkgs.varnish}/sbin/varnishd -a ${cfg.http_address} -f ${pkgs.writeText "default.vcl" cfg.config} -n ${cfg.stateDir} -u varnish";
      serviceConfig.Type = "forking";
    };

    environment.systemPackages = [ pkgs.varnish ];

    users.extraUsers.varnish = {
      group = "varnish";
      uid = config.ids.uids.varnish;
    };

    users.extraGroups.varnish.gid = config.ids.uids.varnish;
  };
}
