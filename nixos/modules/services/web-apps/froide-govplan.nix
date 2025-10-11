{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.froide-govplan;
  pythonFmt = pkgs.formats.pythonVars { };
  settingsFile = pythonFmt.generate "extra_settings.py" cfg.settings;

  pkg = cfg.package.overridePythonAttrs (old: {
    postInstall = old.postInstall + ''
      ln -s ${settingsFile} $out/${pkg.python.sitePackages}/froide_govplan/project/extra_settings.py
    '';
  });

  froide-govplan = pkgs.writeShellApplication {
    name = "froide-govplan";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      SUDO="exec"
      if [[ "$USER" != govplan ]]; then
        SUDO="exec /run/wrappers/bin/sudo -u govplan"
      fi
      $SUDO env ${lib.getExe pkg} "$@"
    '';
  };

  # Service hardening
  defaultServiceConfig = {
    # Secure the services
    ReadWritePaths = [ cfg.dataDir ];
    CacheDirectory = "froide-govplan";
    CapabilityBoundingSet = "";
    # ProtectClock adds DeviceAllow=char-rtc r
    DeviceAllow = "";
    LockPersonality = true;
    MemoryDenyWriteExecute = true;
    NoNewPrivileges = true;
    PrivateDevices = true;
    PrivateMounts = true;
    PrivateTmp = true;
    PrivateUsers = true;
    ProtectClock = true;
    ProtectHome = true;
    ProtectHostname = true;
    ProtectSystem = "strict";
    ProtectControlGroups = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectProc = "invisible";
    ProcSubset = "pid";
    RestrictAddressFamilies = [
      "AF_UNIX"
      "AF_INET"
      "AF_INET6"
    ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    SystemCallArchitectures = "native";
    SystemCallFilter = [
      "@system-service"
      "~@privileged @setuid @keyring"
    ];
    UMask = "0066";
  };

in
{
  options.services.froide-govplan = {

    enable = lib.mkEnableOption "Gouvernment planer web app Govplan";

    package = lib.mkPackageOption pkgs "froide-govplan" { };

    hostName = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      description = "FQDN for the froide-govplan instance.";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/froide-govplan";
      description = "Directory to store the Froide-Govplan server data.";
    };

    secretKeyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to a file containing the secret key.
      '';
    };

    settings = lib.mkOption {
      description = ''
        Configuration options to set in `extra_settings.py`.
      '';

      default = { };

      type = lib.types.submodule {
        freeformType = pythonFmt.type;

        options = {
          ALLOWED_HOSTS = lib.mkOption {
            type = with lib.types; listOf str;
            default = [ "*" ];
            description = ''
              A list of valid fully-qualified domain names (FQDNs) and/or IP
              addresses that can be used to reach the Froide-Govplan service.
            '';
          };
        };
      };
    };

  };

  config = lib.mkIf cfg.enable {

    services.froide-govplan = {
      settings = {
        STATIC_ROOT = "${cfg.dataDir}/static";
        DEBUG = false;
        DATABASES.default = {
          ENGINE = "django.contrib.gis.db.backends.postgis";
          NAME = "govplan";
          USER = "govplan";
          HOST = "/run/postgresql";
        };
      };
    };

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "govplan" ];
      ensureUsers = [
        {
          name = "govplan";
          ensureDBOwnership = true;
        }
      ];
      extensions = ps: with ps; [ postgis ];
    };

    services.nginx = {
      enable = lib.mkDefault true;
      virtualHosts."${cfg.hostName}".locations = {
        "/".extraConfig = "proxy_pass http://unix:/run/froide-govplan/froide-govplan.socket;";
        "/static/".alias = "${cfg.dataDir}/static/";
      };
      proxyTimeout = lib.mkDefault "120s";
    };

    systemd = {
      services = {

        postgresql-setup.serviceConfig.ExecStartPost =
          let
            sqlFile = pkgs.writeText "froide-govplan-postgis-setup.sql" ''
              CREATE EXTENSION IF NOT EXISTS postgis;
            '';
          in
          [
            ''
              ${lib.getExe' config.services.postgresql.package "psql"} -d govplan -f "${sqlFile}"
            ''
          ];

        froide-govplan = {
          description = "Gouvernment planer Govplan";
          serviceConfig = defaultServiceConfig // {
            WorkingDirectory = cfg.dataDir;
            StateDirectory = lib.mkIf (cfg.dataDir == "/var/lib/froide-govplan") "froide-govplan";
            User = "govplan";
            Group = "govplan";
            TimeoutStartSec = "5m";
          };
          after = [
            "postgresql.target"
            "network.target"
            "systemd-tmpfiles-setup.service"
          ];
          wantedBy = [ "multi-user.target" ];
          environment = {
            PYTHONPATH = "${pkg.pythonPath}:${pkg}/${pkg.python.sitePackages}";
            GDAL_LIBRARY_PATH = "${pkgs.gdal}/lib/libgdal.so";
            GEOS_LIBRARY_PATH = "${pkgs.geos}/lib/libgeos_c.so";
          }
          // lib.optionalAttrs (cfg.secretKeyFile != null) {
            SECRET_KEY_FILE = cfg.secretKeyFile;
          };
          preStart = ''
            # Auto-migrate on first run or if the package has changed
            versionFile="${cfg.dataDir}/src-version"
            version=$(cat "$versionFile" 2>/dev/null || echo 0)

            if [[ $version != ${pkg.version} ]]; then
              ${lib.getExe pkg} migrate --no-input
              ${lib.getExe pkg} collectstatic --no-input --clear
              echo ${pkg.version} > "$versionFile"
            fi
          '';
          script = ''
            ${pkg.python.pkgs.uvicorn}/bin/uvicorn --uds /run/froide-govplan/froide-govplan.socket \
              --app-dir ${pkg}/${pkg.python.sitePackages}/froide_govplan \
              project.asgi:application
          '';
        };
      };

    };

    systemd.tmpfiles.rules = [ "d /run/froide-govplan - govplan govplan - -" ];

    environment.systemPackages = [ froide-govplan ];

    users.users.govplan = {
      home = "${cfg.dataDir}";
      isSystemUser = true;
      group = "govplan";
    };
    users.groups.govplan = { };

  };

  meta.maintainers = with lib.maintainers; [ onny ];

}
