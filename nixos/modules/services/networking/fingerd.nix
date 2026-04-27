{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.fingerd;
in
{
  meta.maintainers = with lib.maintainers; [ philocalyst ];

  options.services.fingerd = {
    enable = lib.mkEnableOption "the fingerd finger protocol daemon (Go implementation; unprivileged on Linux per golang/go#1435)";

    package = lib.mkPackageOption pkgs "fingerd" { };

    listen = lib.mkOption {
      type = lib.types.str;
      default = ":79";
      example = ":1079";
      description = ''
        Address to listen on. Use ":1079" with packet redirection for port 79.
        See the package documentation for security recommendations.
      '';
    };

    homesDir = lib.mkOption {
      type = lib.types.str;
      default = "/home";
      description = "Directory containing user home directories.";
    };

    aliasFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = "/etc/finger.conf";
      description = "Path to alias file. Set to null or empty string to disable.";
    };

    extraFlags = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional command-line flags to pass to fingerd.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.fingerd = {
      description = "Finger daemon (Go implementation)";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = lib.escapeShellArgs (
          [
            (lib.getExe cfg.package)
            "-listen"
            cfg.listen
            "-homes-dir"
            cfg.homesDir
          ]
          ++ lib.optionals (cfg.aliasFile != null && cfg.aliasFile != "") [
            "-alias-file"
            cfg.aliasFile
          ]
          ++ cfg.extraFlags
        );

        Restart = "always";
        DynamicUser = true;
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        NoNewPrivileges = true;
        ProtectHome = "read-only";
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        PrivateTmp = true;
        PrivateDevices = true;
        RestrictSUIDSGID = true;
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        ReadOnlyPaths = [
          "/etc"
          cfg.homesDir
        ];
      };
    };
  };
}
