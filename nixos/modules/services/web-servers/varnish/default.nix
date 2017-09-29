{ config, lib, pkgs, ...}:
let
  cfg = config.services.varnish;

in
with lib;
{
  options = {
    services.varnish = {
      enable = mkEnableOption "Varnish Server";

      http_address = mkOption {
        type = types.str;
        default = "*:6081";
        description = "
          HTTP listen address and port.
        ";
      };

      config = mkOption {
        type = types.lines;
        description = "
          Verbatim default.vcl configuration.
        ";
      };

      stateDir = mkOption {
        type = types.path;
        default = "/var/spool/varnish/${config.networking.hostName}";
        description = "
          Directory holding all state for Varnish to run.
        ";
      };

      extraModules = mkOption {
        type = types.listOf types.package;
        default = [];
        example = literalExample "[ pkgs.varnish-geoip ]";
        description = "
          Varnish modules (except 'std').
        ";
      };

      extraCommandLine = mkOption {
        type = types.str;
        default = "";
        example = "-s malloc,256M";
        description = "
          Command line switches for varnishd (run 'varnishd -?' to get list of options)
        ";
      };
    };

  };

  config = mkIf cfg.enable {

    systemd.services.varnish = {
      description = "Varnish";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      preStart = ''
        mkdir -p ${cfg.stateDir}
        chown -R varnish:varnish ${cfg.stateDir}
      '';
      postStop = ''
        rm -rf ${cfg.stateDir}
      '';
      serviceConfig = {
        Type = "simple";
        PermissionsStartOnly = true;
        ExecStart = "${pkgs.varnish}/sbin/varnishd -a ${cfg.http_address} -f ${pkgs.writeText "default.vcl" cfg.config} -n ${cfg.stateDir} -F ${cfg.extraCommandLine}"
          + optionalString (cfg.extraModules != []) " -p vmod_path='${makeSearchPathOutput "lib" "lib/varnish/vmods" ([pkgs.varnish] ++ cfg.extraModules)}' -r vmod_path";
        Restart = "always";
        RestartSec = "5s";
        User = "varnish";
        Group = "varnish";
        AmbientCapabilities = "cap_net_bind_service";
        NoNewPrivileges = true;
        LimitNOFILE = 131072;
      };
    };

    environment.systemPackages = [ pkgs.varnish ];

    users.extraUsers.varnish = {
      group = "varnish";
      uid = config.ids.uids.varnish;
    };

    users.extraGroups.varnish.gid = config.ids.uids.varnish;
  };
}
