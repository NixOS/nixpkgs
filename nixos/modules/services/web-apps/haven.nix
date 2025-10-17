{
  config,
  pkgs,
  lib,
  ...
}:
let
  # Load default values from package. See https://github.com/bitvora/haven/blob/master/.env.example
  defaultSettings = builtins.fromTOML (builtins.readFile "${cfg.package}/share/haven/.env.example");

  import_relays_file = "${pkgs.writeText "import_relays.json" (builtins.toJSON cfg.importRelays)}";
  blastr_relays_file = "${pkgs.writeText "blastr_relays.json" (builtins.toJSON cfg.blastrRelays)}";

  mergedSettings = cfg.settings // {
    IMPORT_SEED_RELAYS_FILE = import_relays_file;
    BLASTR_RELAYS_FILE = blastr_relays_file;
  };

  cfg = config.services.haven;
in
{
  options.services.haven = {
    enable = lib.mkEnableOption "haven";

    package = lib.mkPackageOption pkgs "haven" { };

    blastrRelays = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of relay configurations for blastr";
      example = lib.literalExpression ''
        [
          "relay.example.com"
        ]
      '';
    };

    importRelays = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of relay configurations for importing historical events";
      example = lib.literalExpression ''
        [
          "relay.example.com"
        ]
      '';
    };

    settings = lib.mkOption {
      default = defaultSettings;
      defaultText = "See <https://github.com/bitvora/haven/blob/master/.env.example>";
      apply = lib.recursiveUpdate defaultSettings;
      description = "See <https://github.com/bitvora/haven> for documentation.";
      example = lib.literalExpression ''
        {
          RELAY_URL = "relay.example.com";
          OWNER_NPUB = "npub1...";
        }
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to a file containing sensitive environment variables. See <https://github.com/bitvora/haven> for documentation.
        The file should contain environment-variable assignments like:
        S3_SECRET_KEY=mysecretkey
        S3_ACCESS_KEY_ID=myaccesskey
      '';
      example = "/var/lib/haven/secrets.env";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.haven = {
      description = "Haven daemon user";
      group = "haven";
      isSystemUser = true;
    };

    users.groups.haven = { };

    systemd.services.haven = {
      description = "haven";
      wants = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = lib.attrsets.mapAttrs (
        name: value: if builtins.isBool value then if value then "true" else "false" else toString value
      ) mergedSettings;

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/haven";
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
        User = "haven";
        Group = "haven";
        Restart = "on-failure";

        RuntimeDirectory = "haven";
        StateDirectory = "haven";
        WorkingDirectory = "/var/lib/haven";

        # Create symlink to templates in the working directory
        ExecStartPre = "+${pkgs.coreutils}/bin/ln -sfT ${cfg.package}/share/haven/templates /var/lib/haven/templates";

        PrivateTmp = true;
        PrivateUsers = true;
        PrivateDevices = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        NoNewPrivileges = true;
        MemoryDenyWriteExecute = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectClock = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        ProtectControlGroups = true;
        LockPersonality = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        RestrictRealtime = true;
        ProtectHostname = true;
        CapabilityBoundingSet = "";
        SystemCallFilter = [
          "@system-service"
        ];
        SystemCallArchitectures = "native";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    felixzieger
  ];
}
