{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.tachidesk-server;

in {
  options = {
    services.tachidesk-server = {
      enable = mkEnableOption (mkdoc "A free and open source manga reader server that runs extensions built for Tachiyomi.");

      package = mkOption {
        type = types.package;
        description = mkdoc "Which package to use for the Tachidesk-Server instance";
        relatedPackages = [ "tachidesk-server" ];
      };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/tachidesk-server";
        description = mkdoc ''
          The path to the data directory in which Tachidesk will download scans.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "tachidesk";
        description = mdDoc ''
          User account under which Tachidesk runs.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "tachidesk";
        description = mdDoc ''
          Group under which Tachidesk runs.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = mkdoc ''
          Whether to open the firewall for the port in {option}`services.tachidesk-server.config.port`.
        '';
      };
      
      config = {
        ip = mkOption {
          type = types.str;
          default = "0.0.0.0";
          description = mkdoc ''
            The ip that Tachidesk will bind to.
          '';
        };

        port = mkOption {
          type = types.port;
          default = 8080;
          description = mkDoc ''
            The port that Tachidesk will listen to.
          '';
        };
      };

      extraConfig = mkOption {
        type = types.attrs;
        default = {};
        description = mkDoc ''
          Extra configuration to write in the file `server.conf`.
          See [https://github.com/Suwayomi/Tachidesk-Server/wiki/Configuring-Tachidesk-Server] for more informations.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.config.port ];

    users.groups = mkIf (cfg.group == "tachidesk") {
      tachidesk = {};
    };

    users.users = mkIf (cfg.user == "tachidesk") {
      tachidesk = {
        group = cfg.group;
        home = cfg.dataDir;
        description = "Tachidesk Daemon user";
        isSystemUser = true;
      };
    };

    systemd.services.tachidesk-server = 
      let
        mapAttrToString = attr: (
          let
            attrType = builtins.typeOf attr;
          in if attrType == "string" then ''"${attr}"''
            else if attrType == "int" then ''${toString attr}''
            else if attrType == "bool" then (if attr then ''true'' else ''false'')
            else ''${toString attr}''
        );
        configFile = pkgs.writeText "server.conf" (strings.concatStrings [
          ''
            server.ip = "${cfg.config.ip}"
            server.port = ${toString cfg.config.port}
          ''

          (strings.concatMapStrings (s: s + "\n") ((
            concatLists (mapAttrsToList (name: value: 
              optional (value != null) ''${name} = ${mapAttrToString value}''
            ) cfg.extraConfig)
          )))
        ]);
      in {
      description = "A free and open source manga reader server that runs extensions built for Tachiyomi.";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;

        Type = "simple";
        Restart = "on-failure";
        ExecStartPre = [
          "${pkgs.coreutils}/bin/mkdir -p ${cfg.dataDir}/.local/share/Tachidesk"
          "${pkgs.coreutils}/bin/ln -sf ${configFile} ${cfg.dataDir}/.local/share/Tachidesk/server.conf"
        ];
        ExecStart = "${cfg.package}/bin/tachidesk-server -Dsuwayomi.tachidesk.config.server.rootDir=${cfg.dataDir}";

        StateDirectory = mkIf (cfg.dataDir == "/var/lib/tachidesk-server") "tachidesk-server";
      };
    };
    
  };
}
