{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.froide-food;
  pythonFmt = pkgs.formats.pythonVars { };
  settingsFile = pythonFmt.generate "extra_settings.py" cfg.settings;

  pkg = cfg.package.overridePythonAttrs (old: {
    postInstall = old.postInstall + ''
      ln -s ${settingsFile} $out/${pkg.python.sitePackages}/froide_food/project/extra_settings.py
    '';
  });

  froide-food = pkgs.writeShellApplication {
    name = "froide-food";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      SUDO="exec"
      if [[ "$USER" != food ]]; then
        SUDO="exec /run/wrappers/bin/sudo -u food"
      fi
      $SUDO env ${lib.getExe pkg} "$@"
    '';
  };

  # Service hardening
  defaultServiceConfig = {
    # Secure the services
    ReadWritePaths = [ cfg.dataDir ];
    CacheDirectory = "froide-food";
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
  options.services.froide-food = {

    enable = lib.mkEnableOption "Gouvernment planer web app Govplan";

    package = lib.mkPackageOption pkgs "froide-food" { };

    hostName = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      description = "FQDN for the froide-food instance.";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/froide-food";
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

    services.froide-food = {
      settings = {
        STATIC_ROOT = "${cfg.dataDir}/static";
        DEBUG = false;
        DATABASES.default = {
          ENGINE = "django.contrib.gis.db.backends.postgis";
          NAME = "food";
          USER = "food";
          HOST = "/run/postgresql";
        };
      };
    };

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "food" ];
      ensureUsers = [
        {
          name = "food";
          ensureDBOwnership = true;
        }
      ];
      extensions = ps: with ps; [ postgis ];
    };

    services.nginx = {
      enable = lib.mkDefault true;
      virtualHosts."${cfg.hostName}".locations = {
        "/".extraConfig = "proxy_pass http://unix:/run/froide-food/froide-food.socket;";
        "/static/".alias = "${cfg.dataDir}/static/";
      };
      proxyTimeout = lib.mkDefault "120s";
    };

    systemd = {
      services = {

        postgresql-setup.serviceConfig.ExecStartPost =
          let
            sqlFile = pkgs.writeText "froide-food-postgis-setup.sql" ''
              CREATE EXTENSION IF NOT EXISTS postgis;
            '';
          in
          [
            ''
              ${lib.getExe' config.services.postgresql.package "psql"} -d food -f "${sqlFile}"
            ''
          ];

        froide-food = {
          description = "Gouvernment planer Govplan";
          serviceConfig = defaultServiceConfig // {
            WorkingDirectory = cfg.dataDir;
            StateDirectory = lib.mkIf (cfg.dataDir == "/var/lib/froide-food") "froide-food";
            User = "food";
            Group = "food";
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
            ${pkg.python.pkgs.uvicorn}/bin/uvicorn --uds /run/froide-food/froide-food.socket \
              --app-dir ${pkg}/${pkg.python.sitePackages}/froide_food \
              project.asgi:application
          '';
        };
      };

    };

    systemd.tmpfiles.rules = [ "d /run/froide-food - food food - -" ];

    environment.systemPackages = [ froide-food ];

    users.users.food = {
      home = "${cfg.dataDir}";
      isSystemUser = true;
      group = "food";
    };
    users.groups.food = { };

  };

  meta.maintainers = with lib.maintainers; [ onny ];

}
