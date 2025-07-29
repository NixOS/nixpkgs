{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    mkIf
    types
    ;
  cfg = config.services.readeck;
  settingsFormat = pkgs.formats.toml { };
  configFile = settingsFormat.generate "readeck.toml" cfg.settings;

in
{

  meta.maintainers = [ lib.maintainers.julienmalka ];

  options = {
    services.readeck = {
      enable = mkEnableOption "Readeck";

      package = mkPackageOption pkgs "readeck" { };

      environmentFile = mkOption {
        type = types.nullOr types.path;
        description = ''
          File containing environment variables to be passed to Readeck.
          May be used to provide the Readeck secret key by setting the READECK_SECRET_KEY variable.
        '';
        default = null;
      };

      settings = mkOption {
        type = settingsFormat.type;
        default = { };
        example = {
          main.log_level = "debug";
          server.port = 9000;
        };
        description = ''
          Additional configuration for Readeck, see
          <https://readeck.org/en/docs/configuration>
          for supported values.
        '';
      };

    };
  };

  config = mkIf cfg.enable {
    systemd.services.readeck = {
      description = "Readeck";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        StateDirectory = "readeck";
        WorkingDirectory = "/var/lib/readeck";
        EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
        DynamicUser = true;
        ExecStart = "${lib.getExe cfg.package} serve -config ${configFile}";
        ProtectSystem = "full";
        SystemCallArchitectures = "native";
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        DevicePolicy = "closed";
        ProtectClock = true;
        ProtectHostname = true;
        ProtectProc = "invisible";
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        LockPersonality = true;
        Restart = "on-failure";
      };
    };
  };
}
