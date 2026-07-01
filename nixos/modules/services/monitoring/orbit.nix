{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.orbit;
in
{
  options.services.orbit = {
    enable = lib.mkEnableOption "Fleet Orbit agent" // {
      description = "Enable the Fleet Orbit agent.";
      example = lib.literalExpression ''
        # Use an enrollment secret from a plaintext file managed outside the Nix store.
        {
          services.orbit = {
            enable = true;
            fleetUrl = "https://fleet.example.com";
            enrollSecretPath = "/etc/fleet/enroll-secret";

            desktop.enable = true;
          };
        }

        # Use an enrollment secret from sops-nix.
        { config, ... }:
        {
          sops.secrets.fleet-orbit-enroll-secret = { };

          services.orbit = {
            enable = true;
            fleetUrl = "https://fleet.example.com";
            enrollSecretPath = config.sops.secrets.fleet-orbit-enroll-secret.path;

            desktop.enable = true;
          };
        }
      '';
    };

    orbitPackage = lib.mkPackageOption pkgs "fleet-orbit" { };

    osqueryPackage = lib.mkPackageOption pkgs "osquery" { };

    desktop = {
      enable = lib.mkEnableOption "Fleet Desktop tray application";

      package = lib.mkPackageOption pkgs "fleet-desktop" { };

      alternativeBrowserHost = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "fleet-browser.example.com";
        description = ''
          Alternative host to use for Fleet Desktop browser URLs. This can be
          required when Fleet uses TLS client authentication.
        '';
      };
    };

    fleetUrl = lib.mkOption {
      type = lib.types.str;
      example = "https://fleet.example.com";
      description = "The base URL of the Fleet server.";
    };

    enrollSecretPath = lib.mkOption {
      type = lib.types.path;
      example = "/run/secrets/fleet-enroll-secret";
      description = ''
        Path to a file containing the enroll secret for authenticating to the Fleet server.
        This should point to a secret outside the Nix store, for example a sops-nix or agenix
        secret path.
      '';
    };

    fleetCertificate = lib.mkOption {
      type = lib.types.path;
      default = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
      defaultText = lib.literalExpression "\"\${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt\"";
      description = "Path to the Fleet server certificate chain.";
    };

    debug = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable debug logging.";
    };

    devMode = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Run Orbit in development mode.";
    };

    enableScripts = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Fleet script execution.";
    };

    endUserEmail = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "user@example.com";
      description = "End-user email to pass to Orbit.";
    };

    fleetManagedHostIdentityCertificate = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Configure Orbit to use Fleet-managed host identity certificates.
        This requires a Fleet Enterprise Edition subscription.
      '';
    };

    hostIdentifier = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "uuid"
          "instance"
        ]
      );
      default = null;
      example = "uuid";
      description = "Host identifier mode to use when Orbit and osquery enroll to Fleet.";
    };

    insecure = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Disable TLS certificate verification.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.orbit = {
      description = "Fleet Orbit agent";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      environment = lib.filterAttrs (_: value: value != null) {
        ORBIT_FLEET_URL = cfg.fleetUrl;
        ORBIT_ENROLL_SECRET_PATH = "%d/enroll-secret";
        ORBIT_FLEET_CERTIFICATE = cfg.fleetCertificate;
        ORBIT_DEBUG = lib.boolToString cfg.debug;
        ORBIT_DEV_MODE = lib.boolToString cfg.devMode;
        ORBIT_ENABLE_SCRIPTS = lib.boolToString cfg.enableScripts;
        ORBIT_END_USER_EMAIL = cfg.endUserEmail;
        ORBIT_FLEET_MANAGED_HOST_IDENTITY_CERTIFICATE = lib.boolToString cfg.fleetManagedHostIdentityCertificate;
        ORBIT_HOST_IDENTIFIER = cfg.hostIdentifier;
        ORBIT_INSECURE = lib.boolToString cfg.insecure;
        ORBIT_FLEET_DESKTOP_ALTERNATIVE_BROWSER_HOST = cfg.desktop.alternativeBrowserHost;

        ORBIT_DISABLE_KEYSTORE = "true";
        ORBIT_DISABLE_UPDATES = "true";
        ORBIT_FLEET_DESKTOP = lib.boolToString cfg.desktop.enable;
        ORBIT_LOG_FILE = "/var/log/orbit/orbit.log";
        ORBIT_OSQUERY_DB = "/var/lib/orbit/osquery.db";
        ORBIT_ROOT_DIR = "/var/lib/orbit";
        NIX_ORBIT_OSQUERYD_PATH = lib.getExe' cfg.osqueryPackage "osqueryd";
        NIX_ORBIT_OSQUERY_LOG_PATH = "/var/log/orbit/osquery";
        NIX_ORBIT_DESKTOP_PATH = if cfg.desktop.enable then lib.getExe cfg.desktop.package else null;
      };

      serviceConfig = {
        ExecStart = lib.getExe cfg.orbitPackage;
        LoadCredential = [ "enroll-secret:${cfg.enrollSecretPath}" ];
        StateDirectory = "orbit";
        LogsDirectory = "orbit";
        TimeoutStartSec = 0;
        Restart = "always";
        RestartSec = 60;
        KillMode = "control-group";
        KillSignal = "SIGTERM";
      };
    };
  };
}
