{ config, lib, pkgs, ... }:
let
  inherit (lib) options types mkIf optional optionalAttrs getExe;

  name = "ngrok";
  cfg = config.services.ngrok;

  configFormat = pkgs.formats.yaml { };

  configFileGenerated = configFormat.generate "ngrok-config.yml" cfg.config;

  configFiles = builtins.concatStringsSep "," ((optional (cfg.config != { }) configFileGenerated) ++ cfg.extraConfigFiles);
in
{
  ###### interface
  options.services.ngrok = {
    enable = options.mkEnableOption "Ngrok";

    package = options.mkPackageOption pkgs name { };

    user = options.mkOption {
      type = types.str;
      default = name;
      description = "User account under which ngrok agent runs.";
    };

    group = options.mkOption {
      type = types.str;
      default = name;
      description = "Group account under which ngrok agent runs.";
    };

    config = options.mkOption {
      type = types.submodule {
        freeformType = configFormat.type;
      };

      default = { };
      description = ''
        Config to pass to Ngrok agent.

        See [documentation](https://ngrok.com/docs/agent/config/) for details.
      '';

      example = {
        log = "stdout";
        log_level = "info";
        tunnels = {
          website = {
            addr = "localhost:8080";
            schemes = [ "https" ];
            proto = "http";
            domain = "myapp.ngrok.dev";
          };
        };
      };
    };

    extraConfigFiles = options.mkOption {
      type = with types; listOf path;
      default = [ ];
      description = ''
        Extra config files to inject **after** the declarative config.

        See [documentation](https://ngrok.com/docs/agent/config/#config-file-merging) for details.
      '';
    };

    startArguments = options.mkOption {
      type = types.str;
      default = "--all";
      example = "web dev";
      description = ''
        Arguments & flags to pass to `ngrok start` command.
        Can be used to start only specific tunnel(s), for example.

        See [documentation](https://ngrok.com/docs/agent/cli/#ngrok-start) for details.
      '';
    };
  };

  ###### implementation
  config = mkIf cfg.enable {
    assertions = [{
      assertion = cfg.config != { } || cfg.extraConfigFiles != [ ];
      message = "At least one of `config`, `extraConfigFiles` must be specified.";
    }];

    users = {
      users = optionalAttrs (cfg.user == name) {
        ${name} = {
          description = "Ngrok Agent User";
          group = cfg.group;
          home = "/var/lib/${name}";
          isSystemUser = true;
        };
      };

      groups = optionalAttrs (cfg.group == name) {
        ${name} = { };
      };
    };

    systemd.services.ngrok = {
      description = "Ngrok reverse proxy";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      serviceConfig = {
        ExecStart = "${getExe cfg.package} --config ${configFiles} start ${cfg.startArguments}";
        User = cfg.user;
        Group = cfg.group;
        Restart = "always";
        RestartSec = 15;
        StateDirectory = name;
        Type = "simple";

        # Hardening
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
      };

    };
  };
}
