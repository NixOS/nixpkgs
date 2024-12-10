{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.transfer-sh;
  inherit (lib)
    mkDefault
    mkEnableOption
    mkPackageOption
    mkIf
    mkOption
    types
    mapAttrs
    isBool
    getExe
    boolToString
    optionalAttrs
    ;
in
{
  options.services.transfer-sh = {
    enable = mkEnableOption "Easy and fast file sharing from the command-line";

    package = mkPackageOption pkgs "transfer-sh" { };

    settings = mkOption {
      type = types.submodule {
        freeformType =
          with types;
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

    provider = mkOption {
      type = types.enum [
        "local"
        "s3"
        "storj"
        "gdrive"
      ];
      default = "local";
      description = "Storage providers to use";
    };

    secretFile = mkOption {
      type = types.nullOr types.path;
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
    mkIf cfg.enable {
      services.transfer-sh.settings =
        {
          LISTENER = mkDefault ":8080";
        }
        // optionalAttrs localProvider {
          BASEDIR = mkDefault stateDirectory;
        };

      systemd.services.transfer-sh = {
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        environment = mapAttrs (_: v: if isBool v then boolToString v else toString v) cfg.settings;
        serviceConfig =
          {
            CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
            DevicePolicy = "closed";
            DynamicUser = true;
            ExecStart = "${getExe cfg.package} --provider ${cfg.provider}";
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
          // optionalAttrs (cfg.secretFile != null) {
            EnvironmentFile = cfg.secretFile;
          }
          // optionalAttrs localProvider {
            ReadWritePaths = cfg.settings.BASEDIR;
          };
      };
    };

  meta.maintainers = with lib.maintainers; [ ocfox ];
}
