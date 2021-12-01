{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.galene;
  defaultstateDir = "/var/lib/galene";
  defaultrecordingsDir = "${cfg.stateDir}/recordings";
  defaultgroupsDir = "${cfg.stateDir}/groups";
  defaultdataDir = "${cfg.stateDir}/data";
in
{
  options = {
    services.galene = {
      enable = mkEnableOption "Galene Service.";

      stateDir = mkOption {
        default = defaultstateDir;
        type = types.str;
        description = ''
          The directory where Galene stores its internal state. If left as the default
          value this directory will automatically be created before the Galene server
          starts, otherwise the sysadmin is responsible for ensuring the directory
          exists with appropriate ownership and permissions.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "galene";
        description = "User account under which galene runs.";
      };

      group = mkOption {
        type = types.str;
        default = "galene";
        description = "Group under which galene runs.";
      };

      insecure = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether Galene should listen in http or in https. If left as the default
          value (false), Galene needs to be fed a private key and a certificate.
        '';
      };

      certFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/path/to/your/cert.pem";
        description = ''
          Path to the server's certificate. The file is copied at runtime to
          Galene's data directory where it needs to reside.
        '';
      };

      keyFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/path/to/your/key.pem";
        description = ''
          Path to the server's private key. The file is copied at runtime to
          Galene's data directory where it needs to reside.
        '';
      };

      httpAddress = mkOption {
        type = types.str;
        default = "";
        description = "HTTP listen address for galene.";
      };

      httpPort = mkOption {
        type = types.port;
        default = 8443;
        description = "HTTP listen port.";
      };

      staticDir = mkOption {
        type = types.str;
        default = "${cfg.package.static}/static";
        defaultText = literalExpression ''"''${package.static}/static"'';
        example = "/var/lib/galene/static";
        description = "Web server directory.";
      };

      recordingsDir = mkOption {
        type = types.str;
        default = defaultrecordingsDir;
        example = "/var/lib/galene/recordings";
        description = "Recordings directory.";
      };

      dataDir = mkOption {
        type = types.str;
        default = defaultdataDir;
        example = "/var/lib/galene/data";
        description = "Data directory.";
      };

      groupsDir = mkOption {
        type = types.str;
        default = defaultgroupsDir;
        example = "/var/lib/galene/groups";
        description = "Web server directory.";
      };

      package = mkOption {
        default = pkgs.galene;
        defaultText = literalExpression "pkgs.galene";
        type = types.package;
        description = ''
          Package for running Galene.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.insecure || (cfg.certFile != null && cfg.keyFile != null);
        message = ''
          Galene needs both certFile and keyFile defined for encryption, or
          the insecure flag.
        '';
      }
    ];

    systemd.services.galene = {
      description = "galene";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        ${optionalString (cfg.insecure != true) ''
           install -m 700 -o '${cfg.user}' -g '${cfg.group}' ${cfg.certFile} ${cfg.dataDir}/cert.pem
           install -m 700 -o '${cfg.user}' -g '${cfg.group}' ${cfg.keyFile} ${cfg.dataDir}/key.pem
        ''}
      '';

      serviceConfig = mkMerge [
        {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;
          WorkingDirectory = cfg.stateDir;
          ExecStart = ''${cfg.package}/bin/galene \
          ${optionalString (cfg.insecure) "-insecure"} \
          -data ${cfg.dataDir} \
          -groups ${cfg.groupsDir} \
          -recordings ${cfg.recordingsDir} \
          -static ${cfg.staticDir}'';
          Restart = "always";
          # Upstream Requirements
          LimitNOFILE = 65536;
          StateDirectory = [ ] ++
            optional (cfg.stateDir == defaultstateDir) "galene" ++
            optional (cfg.dataDir == defaultdataDir) "galene/data" ++
            optional (cfg.groupsDir == defaultgroupsDir) "galene/groups" ++
            optional (cfg.recordingsDir == defaultrecordingsDir) "galene/recordings";
        }
      ];
    };

    users.users = mkIf (cfg.user == "galene")
      {
        galene = {
          description = "galene Service";
          group = cfg.group;
          isSystemUser = true;
        };
      };

    users.groups = mkIf (cfg.group == "galene") {
      galene = { };
    };
  };
  meta.maintainers = with lib.maintainers; [ rgrunbla ];
}
