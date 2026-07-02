{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.papra;
  defaultUser = "papra";
  defaultGroup = "papra";
  defaultEnv = {
    SERVER_SERVE_PUBLIC_DIR = true;
    PORT = 1221;
    DATABASE_URL = "file:/var/lib/papra/db.sqlite";
    DOCUMENT_STORAGE_FILESYSTEM_ROOT = "/var/lib/papra/local-documents";
  };
in
{
  options = {
    services.papra = {
      enable = lib.mkEnableOption "Papra";

      user = lib.mkOption {
        default = defaultUser;
        type = lib.types.str;
        description = "User under which Papra runs.";
      };

      group = lib.mkOption {
        default = defaultGroup;
        type = lib.types.str;
        description = ''
          If the default user "${defaultUser}" is configured then this is the primary
          group of that user.
        '';
      };

      package = lib.mkPackageOption pkgs "papra" { };

      environment = lib.mkOption {
        type =
          with lib.types;
          attrsOf (oneOf [
            str
            int
            float
            bool
            path
            package
          ]);
        default = defaultEnv;
        example = {
          PORT = 1221;
        };
        description = "Environment variables to set for the service.";
      };

      environmentFile = lib.mkOption {
        type = with lib.types; nullOr path;
        default = null;
        description = "Environment file, usefult to provide secrets to the service";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    users = {
      users = lib.optionalAttrs (cfg.user == defaultUser) {
        "${defaultUser}" = {
          description = "Papra service user";
          isSystemUser = true;
          group = cfg.group;
        };
      };
      groups = lib.optionalAttrs (cfg.group == defaultGroup) {
        "${defaultGroup}" = { };
      };
    };

    systemd.services.papra = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Restart = "on-failure";
        ExecStartPre = "${lib.getExe pkgs.tsx} ${cfg.package}/lib/src/scripts/migrate-up.script.ts";
        ExecStart = "${cfg.package}/bin/papra";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "papra";
        EnvironmentFile = cfg.environmentFile;
      };
      environment =
        let
          environmentwithDefaults = defaultEnv // cfg.environment;
        in
        (lib.mapAttrs (
          _: s: if lib.isBool s then lib.boolToString s else toString s
        ) environmentwithDefaults);
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ wariuccio ];
  };
}
