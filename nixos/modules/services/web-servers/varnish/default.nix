{ config, lib, pkgs, ...}:

with lib;

let
  cfg = config.services.varnish;

  commandLine = "-f ${pkgs.writeText "default.vcl" cfg.config}" +
      optionalString (cfg.extraModules != []) " -p vmod_path='${makeSearchPathOutput "lib" "lib/varnish/vmods" ([cfg.package] ++ cfg.extraModules)}' -r vmod_path";
in
{
  options = {
    services.varnish = {
      enable = mkEnableOption "Varnish Server";

      package = mkOption {
        type = types.package;
        default = pkgs.varnish5;
        defaultText = "pkgs.varnish5";
        description = ''
          The package to use
        '';
      };

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
        example = literalExample "[ pkgs.varnish5Packages.geoip ]";
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
        ExecStart = "${cfg.package}/sbin/varnishd -a ${cfg.http_address} -n ${cfg.stateDir} -F ${cfg.extraCommandLine} ${commandLine}";
        Restart = "always";
        RestartSec = "5s";
        User = "varnish";
        Group = "varnish";
        AmbientCapabilities = "cap_net_bind_service";
        NoNewPrivileges = true;
        LimitNOFILE = 131072;
      };
    };

    environment.systemPackages = [ cfg.package ];

    # check .vcl syntax at compile time (e.g. before nixops deployment)
    system.extraDependencies = [
      (pkgs.stdenv.mkDerivation {
        name = "check-varnish-syntax";
        buildCommand = "${cfg.package}/sbin/varnishd -C ${commandLine} 2> $out || (cat $out; exit 1)";
      })
    ];

    users.extraUsers.varnish = {
      group = "varnish";
      uid = config.ids.uids.varnish;
    };

    users.extraGroups.varnish.gid = config.ids.uids.varnish;
  };
}
