{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.varnish;

  commandLine =
    "-f ${pkgs.writeText "default.vcl" cfg.config}"
    +
      lib.optionalString (cfg.extraModules != [ ])
        " -p vmod_path='${
           lib.makeSearchPathOutput "lib" "lib/varnish/vmods" ([ cfg.package ] ++ cfg.extraModules)
         }' -r vmod_path";
in
{
  options = {
    services.varnish = {
      enable = lib.mkEnableOption "Varnish Server";

      enableConfigCheck = lib.mkEnableOption "checking the config during build time" // {
        default = true;
      };

      package = lib.mkPackageOption pkgs "varnish" { };

      http_address = lib.mkOption {
        type = lib.types.str;
        default = "*:6081";
        description = ''
          HTTP listen address and port.
        '';
      };

      config = lib.mkOption {
        type = lib.types.lines;
        description = ''
          Verbatim default.vcl configuration.
        '';
      };

      stateDir = lib.mkOption {
        type = lib.types.path;
        default = "/run/varnish/${config.networking.hostName}";
        defaultText = lib.literalExpression ''"/run/varnish/''${config.networking.hostName}"'';
        description = ''
          Directory holding all state for Varnish to run. Note that this should be a tmpfs in order to avoid performance issues and crashes.
        '';
      };
      extraModules = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        example = lib.literalExpression "[ pkgs.varnishPackages.geoip ]";
        description = ''
          Varnish modules (except 'std').
        '';
      };

      extraCommandLine = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "-s malloc,256M";
        description = ''
          Command line switches for varnishd (run 'varnishd -?' to get list of options)
        '';
      };
    };

  };

  config = lib.mkIf cfg.enable {
    systemd.services.varnish = {
      description = "Varnish";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      preStart = lib.mkIf (!(lib.hasPrefix "/run/" cfg.stateDir)) ''
        mkdir -p ${cfg.stateDir}
        chown -R varnish:varnish ${cfg.stateDir}
      '';
      postStop = lib.mkIf (!(lib.hasPrefix "/run/" cfg.stateDir)) ''
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
        RuntimeDirectory = lib.mkIf (lib.hasPrefix "/run/" cfg.stateDir) (
          lib.removePrefix "/run/" cfg.stateDir
        );
        AmbientCapabilities = "cap_net_bind_service";
        NoNewPrivileges = true;
        LimitNOFILE = 131072;
      };
    };

    environment.systemPackages = [ cfg.package ];

    # check .vcl syntax at compile time (e.g. before nixops deployment)
    system.checks = lib.mkIf cfg.enableConfigCheck [
      (pkgs.runCommand "check-varnish-syntax" { } ''
        ${cfg.package}/bin/varnishd -C ${commandLine} 2> $out || (cat $out; exit 1)
      '')
    ];

    users.users.varnish = {
      group = "varnish";
      uid = config.ids.uids.varnish;
    };

    users.groups.varnish.gid = config.ids.uids.varnish;
  };
}
