{
  config,
  pkgs,
  lib,
  utils,
  ...
}:

let
  cfg = config.services.unpackerr;
  configFormat = pkgs.formats.toml { };
  configFile = configFormat.generate "unpackerr.conf" cfg.settings;
  inherit (lib)
    mkEnableOption
    mkOption
    mkPackageOption
    mkIf
    getExe
    ;
  inherit (lib.types) types;
in
{
  options = {
    services.unpackerr = {
      enable = mkEnableOption "Unpackerr";

      settings = mkOption {
        type = configFormat.type;
        default = {
          # Config needs to be non-empty, otherwise unpackerr
          # crashes. debug=false is the default value.
          debug = false;
        };
        example = {
          radarr = [
            {
              url = "http://127.0.0.1:8989";
              api_key = "0123456789abcdef0123456789abcdef";
            }
          ];
          sonarr = [
            {
              url = "http://127.0.0.1:7878";
              api_key = "0123456789abcdef0123456789abcdef";
            }
          ];
        };
        description = ''
          Unpackerr TOML configuration as a Nix attribute set.
          Refer to [Unpackerr docs](https://unpackerr.zip/docs/install/configuration) for details.
          For setting secrets refer to this [section](https://unpackerr.zip/docs/install/configuration/#secrets-and-passwords).
        '';
      };

      environmentFiles = mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        example = [ "/run/secrets/unpackerr.env" ];
        description = ''
          Environment file to pass secret configuration values.
          Refer to [Unpackerr docs](https://unpackerr.zip/docs/install/configuration) for details.
          For setting secrets refer to this [section](https://unpackerr.zip/docs/install/configuration/#secrets-and-passwords).
        '';
      };

      user = mkOption {
        type = types.str;
        default = "unpackerr";
        description = "User account under which Unpackerr runs.";
      };

      group = mkOption {
        type = types.str;
        default = "unpackerr";
        description = "Group under which Unpackerr runs.";
      };

      package = mkPackageOption pkgs "unpackerr" { };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.unpackerr = {
      description = "Unpackerr - archive extraction daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "unpackerr";
        LogsDirectory = "unpackerr";
        ExecStart = utils.escapeSystemdExecArgs [
          (getExe cfg.package)
          "-c"
          configFile
        ];
        Restart = "always";
        RestartSec = 10;
        UMask = "0002";
        WorkingDirectory = "/tmp";

        # Hardening
        LockPersonality = true;
        PrivateDevices = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RestrictNamespaces = true;
        RemoveIPC = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectClock = true;
        ProtectHostname = true;
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        NoNewPrivileges = true;
        CapabilityBoundingSet = [ "" ];
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        SystemCallArchitectures = "native";
      };
    };

    users.users = mkIf (cfg.user == "unpackerr") {
      unpackerr = {
        inherit (cfg) group;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "unpackerr") {
      unpackerr = { };
    };
  };

  meta = with lib; {
    maintainers = with lib.maintainers; [ Wekuz ];
  };
}
