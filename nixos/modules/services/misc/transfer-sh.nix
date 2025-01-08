{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.transfer-sh;
in
{
  options.services.transfer-sh = {
    enable = lib.mkEnableOption "Easy and fast file sharing from the command-line";

    package = lib.mkPackageOption pkgs "transfer-sh" { };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType =
          with lib.types;
          attrsOf (oneOf [
            bool
            int
            str
          ]);
      };
      default = { };
      example = {
        LISTENER = ":8080";
        BASEDIR = "/var/lib/transfer.sh";
        TLS_LISTENER_ONLY = false;
      };
      description = ''
        Additional configuration for transfer-sh, see
        <https://github.com/dutchcoders/transfer.sh#usage-1>
        for supported values.

        For secrets use secretFile option instead.
      '';
    };

    provider = lib.mkOption {
      type = lib.types.enum [
        "local"
        "s3"
        "storj"
        "gdrive"
      ];
      default = "local";
      description = "Storage providers to use";
    };

    secretFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/transfer-sh.env";
      description = ''
        Path to file containing environment variables.
        Useful for passing down secrets.
        Some variables that can be considered secrets are:
         - AWS_ACCESS_KEY
         - AWS_ACCESS_KEY
         - TLS_PRIVATE_KEY
         - HTTP_AUTH_HTPASSWD
      '';
    };
  };

  config =
    let
      localProvider = (cfg.provider == "local");
      stateDirectory = "/var/lib/transfer.sh";
    in
    lib.mkIf cfg.enable {
      services.transfer-sh.settings =
        {
          LISTENER = lib.mkDefault ":8080";
        }
        // lib.optionalAttrs localProvider {
          BASEDIR = lib.mkDefault stateDirectory;
        };

      systemd.services.transfer-sh = {
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        environment = lib.mapAttrs (_: v: if lib.isBool v then lib.boolToString v else toString v) cfg.settings;
        serviceConfig =
          {
            DevicePolicy = "closed";
            DynamicUser = true;
            ExecStart = "${lib.getExe cfg.package} --provider ${cfg.provider}";
            LockPersonality = true;
            MemoryDenyWriteExecute = true;
            PrivateDevices = true;
            PrivateUsers = true;
            ProtectClock = true;
            ProtectControlGroups = true;
            ProtectHostname = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProtectProc = "invisible";
            RestrictAddressFamilies = [
              "AF_INET"
              "AF_INET6"
            ];
            RestrictNamespaces = true;
            RestrictRealtime = true;
            SystemCallArchitectures = [ "native" ];
            SystemCallFilter = [ "@system-service" ];
            StateDirectory = baseNameOf stateDirectory;
          }
          // lib.optionalAttrs (cfg.secretFile != null) {
            EnvironmentFile = cfg.secretFile;
          }
          // lib.optionalAttrs localProvider {
            ReadWritePaths = cfg.settings.BASEDIR;
          };
      };
    };

  meta.maintainers = with lib.maintainers; [ ocfox ];
}
