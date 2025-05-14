{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.unit;

  configFile = pkgs.writeText "unit.json" cfg.config;

in
{
  options = {
    services.unit = {
      enable = mkEnableOption "Unit App Server";
      package = mkPackageOption pkgs "unit" { };
      user = mkOption {
        type = types.str;
        default = "unit";
        description = "User account under which unit runs.";
      };
      group = mkOption {
        type = types.str;
        default = "unit";
        description = "Group account under which unit runs.";
      };
      stateDir = mkOption {
        type = types.path;
        default = "/var/spool/unit";
        description = "Unit data directory.";
      };
      logDir = mkOption {
        type = types.path;
        default = "/var/log/unit";
        description = "Unit log directory.";
      };
      config = mkOption {
        type = types.str;
        default = ''
          {
            "listeners": {},
            "applications": {}
          }
        '';
        example = ''
          {
            "listeners": {
              "*:8300": {
                "application": "example-php-72"
              }
            },
            "applications": {
              "example-php-72": {
                "type": "php 7.2",
                "processes": 4,
                "user": "nginx",
                "group": "nginx",
                "root": "/var/www",
                "index": "index.php",
                "options": {
                  "file": "/etc/php.d/default.ini",
                  "admin": {
                    "max_execution_time": "30",
                    "max_input_time": "30",
                    "display_errors": "off",
                    "display_startup_errors": "off",
                    "open_basedir": "/dev/urandom:/proc/cpuinfo:/proc/meminfo:/etc/ssl/certs:/var/www",
                    "disable_functions": "exec,passthru,shell_exec,system"
                  }
                }
              }
            }
          }
        '';
        description = "Unit configuration in JSON format. More details here https://unit.nginx.org/configuration";
      };
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    systemd.tmpfiles.rules = [
      "d '${cfg.stateDir}' 0750 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.logDir}' 0750 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.unit = {
      description = "Unit App Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        [ ! -e '${cfg.stateDir}/conf.json' ] || rm -f '${cfg.stateDir}/conf.json'
      '';
      postStart = ''
        ${pkgs.curl}/bin/curl -X PUT --data-binary '@${configFile}' --unix-socket '/run/unit/control.unit.sock' 'http://localhost/config'
      '';
      serviceConfig = {
        Type = "forking";
        PIDFile = "/run/unit/unit.pid";
        ExecStart = ''
          ${cfg.package}/bin/unitd --control 'unix:/run/unit/control.unit.sock' --pid '/run/unit/unit.pid' \
                                   --log '${cfg.logDir}/unit.log' --statedir '${cfg.stateDir}' --tmpdir '/tmp' \
                                   --user ${cfg.user} --group ${cfg.group}
        '';
        ExecStop = ''
          ${pkgs.curl}/bin/curl -X DELETE --unix-socket '/run/unit/control.unit.sock' 'http://localhost/config'
        '';
        # Runtime directory and mode
        RuntimeDirectory = "unit";
        RuntimeDirectoryMode = "0750";
        # Access write directories
        ReadWritePaths = [
          cfg.stateDir
          cfg.logDir
        ];
        # Security
        NoNewPrivileges = true;
        # Sandboxing
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateUsers = false;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        PrivateMounts = true;
        # System Call Filtering
        SystemCallArchitectures = "native";
      };
    };

    users.users = optionalAttrs (cfg.user == "unit") {
      unit = {
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = optionalAttrs (cfg.group == "unit") {
      unit = { };
    };

  };
}
