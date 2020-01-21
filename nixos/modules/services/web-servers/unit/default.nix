{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.unit;

  configFile = pkgs.writeText "unit.json" cfg.config;

in {
  options = {
    services.unit = {
      enable = mkEnableOption "Unit App Server";
      package = mkOption {
        type = types.package;
        default = pkgs.unit;
        defaultText = "pkgs.unit";
        description = "Unit package to use.";
      };
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
        default = "/var/spool/unit";
        description = "Unit data directory.";
      };
      logDir = mkOption {
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
        example = literalExample ''
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
      path = with pkgs; [ curl ];
      preStart = ''
        test -f '${cfg.stateDir}/conf.json' || rm -f '${cfg.stateDir}/conf.json'
      '';
      postStart = ''
        curl -X PUT --data-binary '@${configFile}' --unix-socket '/run/unit/control.unit.sock' 'http://localhost/config'
      '';
      serviceConfig = {
        ExecStart = ''
          ${cfg.package}/bin/unitd --control 'unix:/run/unit/control.unit.sock' --pid '/run/unit/unit.pid' \
                                   --log '${cfg.logDir}/unit.log' --state '${cfg.stateDir}' --no-daemon \
                                   --user ${cfg.user} --group ${cfg.group}
        '';
        # User and group
        User = cfg.user;
        Group = cfg.group;
        # Capabilities
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" "CAP_SETGID" "CAP_SETUID" ];
        # Security
        NoNewPrivileges = true;
        # Sandboxing
        ProtectSystem = "full";
        ProtectHome = true;
        RuntimeDirectory = "unit";
        RuntimeDirectoryMode = "0750";
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHostname = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        PrivateMounts = true;
      };
    };

    users.users = optionalAttrs (cfg.user == "unit") {
      unit.group = cfg.group;
      isSystemUser = true;
    };

    users.groups = optionalAttrs (cfg.group == "unit") {
      unit = { };
    };

  };
}
