{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.services.hledger;

in

{
  options = {
    services.hledger = {
      web = {
        enable = mkEnableOption "hledger-web accounting webserver";
        listenHost = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = ''
            Address and port this hledger-web instance listens to.
          '';
        };
        listenPort = mkOption {
          type = types.str;
          default = "5000";
          description = ''
            Port this hledger-web instance listens to.
          '';
        };
        baseURL = mkOption {
          type = types.str;
          default = "http://127.0.0.1:${cfg.web.listenPort}/";
          description = ''
            Base URL of this hledger-web instance.
          '';
        };
      };
      api = {
        enable = mkEnableOption "hledger-api accounting apiserver";
        listenHost = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = ''
            Address and port this hledger-api instance listens to.
          '';
        };
        listenPort = mkOption {
          type = types.str;
          default = "8001";
          description = ''
            Port this hledger-api instance listens to.
          '';
        };
      };

      statePath = mkOption {
        type = types.str;
        default = "/var/lib/hledger";
        description = "hledger working directory";
      };

      stateFileName = mkOption {
        type = types.str;
        default = ".hledger.journal";
        description = "hledger filename";
      };

      user = mkOption {
        type = types.str;
        default = "hledger";
        description = ''
          User which runs the hledger-web service.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "hledger";
        description = ''
          Group which runs the hledger-web service.
        '';
      };

    };
  };

  config = mkMerge [ (mkIf (cfg.web.enable || cfg.api.enable) {
    users.extraUsers = optionalAttrs (cfg.user == "hledger") (singleton {
      name = "hledger";
      group = cfg.group;
      home = cfg.statePath;
      createHome = true;
    });

    users.extraGroups = optionalAttrs (cfg.group == "hledger") (singleton {
      name = "hledger";
    });

  }) (mkIf cfg.web.enable {
    systemd.services.hledger-web = {
      description = "hledger-web accounting";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      preStart = ''
        mkdir -p ${cfg.statePath}
        chown -R ${cfg.user}:${cfg.group} ${cfg.statePath}
        touch ${cfg.statePath}/${cfg.stateFileName}
      '';
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        PermissionsStartOnly = true;
        ExecStart = "${pkgs.hledger-web}/bin/hledger-web --serve --base-url=${cfg.web.baseURL} --host ${cfg.web.listenHost} --port ${cfg.web.listenPort} --file ${cfg.statePath}/${cfg.stateFileName}";
        WorkingDirectory = "${cfg.statePath}";
        Restart = "always";
        RestartSec = "10";
      };
    };
  }) (mkIf cfg.api.enable {
    systemd.services.hledger-api = {
      description = "hledger-api accounting";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      preStart = ''
        mkdir -p ${cfg.statePath}
        chown -R ${cfg.user}:${cfg.group} ${cfg.statePath}
        touch ${cfg.statePath}/${cfg.stateFileName}
      '';
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        PermissionsStartOnly = true;
        ExecStart = "${pkgs.hledger-api}/bin/hledger-api --host ${cfg.api.listenHost} --port ${cfg.api.listenPort} --file ${cfg.statePath}/${cfg.stateFileName}";
        WorkingDirectory = "${cfg.statePath}";
        Restart = "always";
        RestartSec = "10";
      };
    };
  })];
}
