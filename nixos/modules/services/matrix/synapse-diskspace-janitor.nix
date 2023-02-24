{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.matrix-synapse-diskspace-janitor;

  format = pkgs.formats.json { };
  configFile = format.generate "synapse-diskspace-janitor-config.json" cfg.settings;
in
{
  meta.maintainers = with maintainers; [ ckie ];
  options.services.matrix-synapse-diskspace-janitor = {
    enable = mkEnableOption (lib.mdDoc "matrix-synapse-diskspace-janitor");
    package = mkOption {
      type = types.package;
      default = pkgs.matrix-synapse-tools.matrix-synapse-diskspace-janitor;
      defaultText = lib.literalExpression "pkgs.matrix-synapse-tools.matrix-synapse-diskspace-janitor";
      description = lib.mdDoc "matrix-synapse-diskspace-janitor package to use";
    };

    adminTokenFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = lib.mdDoc ''
        Path to a file containing the value of `MatrixAdminToken`. This should be used
        to avoid exposing the `MatrixAdminToken` to the Nix store.
      '';
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = format.type;
      };
      default = { };
      description = lib.mdDoc ''
        Generates the configuration file. Refer to
        <https://git.cyberia.club/cyberia/matrix-synapse-diskspace-janitor#configuration-overview>
        for details on supported values.
      '';
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/matrix-synapse-diskspace-janitor";
      description = lib.mdDoc ''
        Data directory for matrix-synapse-diskspace-janitor.
      '';
    };
  };

  config = mkIf cfg.enable {
    # error: evaluation aborted with the following error message: 'Group name 'matrix-synapse-diskspace-janitor' is longer than 31 characters which is not allowed!'
    users.users.synapse-diskspace-janitor = {
      group = "matrix-synapse";
      home = cfg.dataDir;
      createHome = true;
      uid = config.ids.uids.synapse-diskspace-janitor;
    };

    systemd.services.matrix-synapse-diskspace-janitor = {
      description = "Matrix Synapse Disk Space Janitor";
      documentation = [ "https://git.cyberia.club/cyberia/matrix-synapse-diskspace-janitor" ];
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      script = ''
        ${lib.optionalString (cfg.adminTokenFile != null) ''
          # Environment variables override the config file.
          export JANITOR_MATRIXADMINTOKEN=$(cat "''${CREDENTIALS_DIRECTORY}/admin-token-file")
        ''}

        ln -fs "${configFile}" config.json
        rm frontend; ln -fs "${cfg.package.src}/frontend" frontend
        exec ${cfg.package}/bin/matrix-synapse-diskspace-janitor
      '';

      serviceConfig = {
        LoadCredential = lib.mkIf (cfg.adminTokenFile != null) "admin-token-file:${cfg.adminTokenFile}";

        StateDirectory = "matrix-synapse-diskspace-janitor";
        WorkingDirectory = "/var/lib/matrix-synapse-diskspace-janitor";
        # DynamicUser = true;
        User = "synapse-diskspace-janitor";
        Group = "matrix-synapse";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateUsers = true;
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        Restart = "on-failure";
        RestartSec = 10;
        StartLimitBurst = 5;
      };
    };
  };
}
