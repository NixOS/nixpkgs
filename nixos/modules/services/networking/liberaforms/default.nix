{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.liberaforms;

  format = pkgs.formats.pythonVars { };
  settingsFile = format.generate "dotenv" cfg.settings;
in

{
  imports = [
    ./reverse-proxy.nix
  ];

  options.services.liberaforms = {
    enable = lib.mkEnableOption "LiberaForms";
    package = lib.mkPackageOption pkgs "liberaforms" { };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8000;
      description = "Liberaforms service port.";
    };

    openPorts = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open the ports in the firewall";
    };

    settings = lib.mkOption {
      type = lib.types.submodule (lib.modules.importApply ./settings.nix { inherit format; });
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
      requires = [ "postgresql.target" ];
      after = [
        "network.target"
        "postgresql.target"
      ];
      environment = {
        PGHOST = "/run/postgresql";
        PGDATABASE = "liberaforms";
        ENV_FILE = settingsFile;
        UPLOADS_DIR = "/var/lib/liberaforms/uploads";
      };
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
      users.liberaforms = {
        isSystemUser = true;
        group = "liberaforms";
      };
      groups.liberaforms = { };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openPorts [ cfg.port ];
    networking.firewall.allowedUDPPorts = lib.mkIf cfg.openPorts [ cfg.port ];
  };
}
