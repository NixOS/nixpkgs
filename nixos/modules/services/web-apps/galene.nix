{ config, lib, options, pkgs, ... }:

let
  cfg = config.services.galene;
  opt = options.services.galene;
  defaultstateDir = "/var/lib/galene";
  defaultrecordingsDir = "${cfg.stateDir}/recordings";
  defaultgroupsDir = "${cfg.stateDir}/groups";
  defaultdataDir = "${cfg.stateDir}/data";
in
{
  options = {
    services.galene = {
      enable = lib.mkEnableOption "Galene Service";

      stateDir = lib.mkOption {
        default = defaultstateDir;
        type = lib.types.str;
        description = ''
          The directory where Galene stores its internal state. If left as the default
          value this directory will automatically be created before the Galene server
          starts, otherwise the sysadmin is responsible for ensuring the directory
          exists with appropriate ownership and permissions.
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "galene";
        description = "User account under which galene runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "galene";
        description = "Group under which galene runs.";
      };

      insecure = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether Galene should listen in http or in https. If left as the default
          value (false), Galene needs to be fed a private key and a certificate.
        '';
      };

      certFile = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "/path/to/your/cert.pem";
        description = ''
          Path to the server's certificate. The file is copied at runtime to
          Galene's data directory where it needs to reside.
        '';
      };

      keyFile = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "/path/to/your/key.pem";
        description = ''
          Path to the server's private key. The file is copied at runtime to
          Galene's data directory where it needs to reside.
        '';
      };

      httpAddress = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "HTTP listen address for galene.";
      };

      httpPort = lib.mkOption {
        type = lib.types.port;
        default = 8443;
        description = "HTTP listen port.";
      };

      turnAddress = lib.mkOption {
        type = lib.types.str;
        default = "auto";
        example = "127.0.0.1:1194";
        description = "Built-in TURN server listen address and port. Set to \"\" to disable.";
      };

      staticDir = lib.mkOption {
        type = lib.types.str;
        default = "${cfg.package.static}/static";
        defaultText = lib.literalExpression ''"''${package.static}/static"'';
        example = "/var/lib/galene/static";
        description = "Web server directory.";
      };

      recordingsDir = lib.mkOption {
        type = lib.types.str;
        default = defaultrecordingsDir;
        defaultText = lib.literalExpression ''"''${config.${opt.stateDir}}/recordings"'';
        example = "/var/lib/galene/recordings";
        description = "Recordings directory.";
      };

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = defaultdataDir;
        defaultText = lib.literalExpression ''"''${config.${opt.stateDir}}/data"'';
        example = "/var/lib/galene/data";
        description = "Data directory.";
      };

      groupsDir = lib.mkOption {
        type = lib.types.str;
        default = defaultgroupsDir;
        defaultText = lib.literalExpression ''"''${config.${opt.stateDir}}/groups"'';
        example = "/var/lib/galene/groups";
        description = "Web server directory.";
      };

      package = lib.mkPackageOption pkgs "galene" { };
    };
  };

  config = lib.mkIf cfg.enable {
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
        ${lib.optionalString (cfg.insecure != true) ''
           install -m 700 -o '${cfg.user}' -g '${cfg.group}' ${cfg.certFile} ${cfg.dataDir}/cert.pem
           install -m 700 -o '${cfg.user}' -g '${cfg.group}' ${cfg.keyFile} ${cfg.dataDir}/key.pem
        ''}
      '';

      serviceConfig = lib.mkMerge [
        {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;
          WorkingDirectory = cfg.stateDir;
          ExecStart = ''${cfg.package}/bin/galene \
          ${lib.optionalString (cfg.insecure) "-insecure"} \
          -http ${cfg.httpAddress}:${toString cfg.httpPort} \
          -turn ${cfg.turnAddress} \
          -data ${cfg.dataDir} \
          -groups ${cfg.groupsDir} \
          -recordings ${cfg.recordingsDir} \
          -static ${cfg.staticDir}'';
          Restart = "always";
          # Upstream Requirements
          LimitNOFILE = 65536;
          StateDirectory = [ ] ++
            lib.optional (cfg.stateDir == defaultstateDir) "galene" ++
            lib.optional (cfg.dataDir == defaultdataDir) "galene/data" ++
            lib.optional (cfg.groupsDir == defaultgroupsDir) "galene/groups" ++
            lib.optional (cfg.recordingsDir == defaultrecordingsDir) "galene/recordings";

          # Hardening
          CapabilityBoundingSet = [ "" ];
          DeviceAllow = [ "" ];
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateTmp = true;
          PrivateUsers = true;
          ProcSubset = "pid";
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ProtectSystem = "strict";
          ReadWritePaths = cfg.recordingsDir;
          RemoveIPC = true;
          RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_NETLINK" ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [ "@system-service" "~@privileged" ];
          UMask = "0077";
        }
      ];
    };

    users.users = lib.mkIf (cfg.user == "galene")
      {
        galene = {
          description = "galene Service";
          group = cfg.group;
          isSystemUser = true;
        };
      };

    users.groups = lib.mkIf (cfg.group == "galene") {
      galene = { };
    };
  };
  meta.maintainers = with lib.maintainers; [ rgrunbla ];
}
