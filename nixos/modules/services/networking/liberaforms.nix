{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.liberaforms;
in
{
  options.services.liberaforms = {
    enable = lib.mkEnableOption "LiberaForms";
    package = lib.mkPackageOption pkgs "liberaforms" { };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf lib.types.str;
        options = { };
      };
      default = { };
      description = ''
        Configuration for LiberaForms, which will be passed as environment variables.
        See <https://codeberg.org/LiberaForms/server/src/branch/main/dotenv.example>.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.liberaforms = {
      description = "LiberaForms";
      wantedBy = [ "multi-user.target" ];
      requires = [ "postgresql.service" ];
      after = [
        "network.target"
        "postgresql.service"
      ];
      environment = {
        PGHOST = "/run/postgresql";
        PGDATABASE = "liberaforms";
        TMP_DIR = "/tmp";
        LOG_DIR = "/var/log/liberaforms";
        UPLOADS_DIR = "/var/lib/liberaforms/uploads";
      }
      // cfg.settings;
      serviceConfig = {
        User = "liberaforms";
        Group = "liberaforms";
        ExecStart = lib.getExe cfg.package;
        CacheDirectory = "liberaforms";
        LogsDirectory = "liberaforms";
        StateDirectory = "liberaforms";
        WorkingDirectory = "%S/liberaforms";
      };
      preStart = ''
        ${lib.getExe' cfg.package "liberaforms-flask"} database upgrade
      '';
    };

    services.postgresql = {
      enable = true;
      ensureUsers = [
        {
          name = "liberaforms";
          ensureDBOwnership = true;
        }
      ];
      ensureDatabases = [ "liberaforms" ];
    };

    users = {
      groups.liberaforms = { };
      users.liberaforms = {
        isSystemUser = true;
        group = "liberaforms";
      };
    };
  };
}
