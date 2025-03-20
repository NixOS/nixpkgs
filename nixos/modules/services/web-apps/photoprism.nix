{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.photoprism;

  env = {
    PHOTOPRISM_ORIGINALS_PATH = cfg.originalsPath;
    PHOTOPRISM_STORAGE_PATH = cfg.storagePath;
    PHOTOPRISM_IMPORT_PATH = cfg.importPath;
    PHOTOPRISM_HTTP_HOST = cfg.address;
    PHOTOPRISM_HTTP_PORT = toString cfg.port;
  } // (lib.mapAttrs (_: toString) cfg.settings);

  manage = pkgs.writeShellScript "manage" ''
    set -o allexport # Export the following env vars
    ${lib.toShellVars env}
    eval "$(${config.systemd.package}/bin/systemctl show -pUID,MainPID photoprism.service | ${pkgs.gnused}/bin/sed "s/UID/ServiceUID/")"
    exec ${pkgs.util-linux}/bin/nsenter \
      -t $MainPID -m -S $ServiceUID -G $ServiceUID --wdns=${cfg.storagePath} \
      ${cfg.package}/bin/photoprism "$@"
  '';
in
{
  meta.maintainers = with lib.maintainers; [ stunkymonkey ];

  options.services.photoprism = {

    enable = lib.mkEnableOption "Photoprism web server";

    passwordFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Admin password file.
      '';
    };

    address = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      description = ''
        Web interface address.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 2342;
      description = ''
        Web interface port.
      '';
    };

    originalsPath = lib.mkOption {
      type = lib.types.path;
      default = null;
      example = "/data/photos";
      description = ''
        Storage path of your original media files (photos and videos).
      '';
    };

    importPath = lib.mkOption {
      type = lib.types.str;
      default = "import";
      description = ''
        Relative or absolute to the `originalsPath` from where the files should be imported.
      '';
    };

    storagePath = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/photoprism";
      description = ''
        Location for sidecar, cache, and database files.
      '';
    };

    package = lib.mkPackageOption pkgs "photoprism" { };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = ''
        See [the getting-started guide](https://docs.photoprism.app/getting-started/config-options/) for available options.
      '';
      example = {
        PHOTOPRISM_DEFAULT_LOCALE = "de";
        PHOTOPRISM_ADMIN_USER = "root";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.photoprism = {
      description = "Photoprism server";

      serviceConfig = {
        Restart = "on-failure";
        User = "photoprism";
        Group = "photoprism";
        DynamicUser = true;
        StateDirectory = "photoprism";
        WorkingDirectory = "/var/lib/photoprism";
        RuntimeDirectory = "photoprism";
        ReadWritePaths = [
          cfg.originalsPath
          cfg.importPath
          cfg.storagePath
        ];

        LoadCredential = lib.optionalString (
          cfg.passwordFile != null
        ) "PHOTOPRISM_ADMIN_PASSWORD:${cfg.passwordFile}";

        LockPersonality = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@setuid @keyring"
        ];
        UMask = "0066";
      };

      wantedBy = [ "multi-user.target" ];
      environment = env;

      # reminder: easier password configuration will come in https://github.com/photoprism/photoprism/pull/2302
      preStart = ''
        ln -sf ${manage} photoprism-manage

        ${lib.optionalString (cfg.passwordFile != null) ''
          export PHOTOPRISM_ADMIN_PASSWORD=$(cat "$CREDENTIALS_DIRECTORY/PHOTOPRISM_ADMIN_PASSWORD")
        ''}
        exec ${cfg.package}/bin/photoprism migrations run -f
      '';

      script = ''
        ${lib.optionalString (cfg.passwordFile != null) ''
          export PHOTOPRISM_ADMIN_PASSWORD=$(cat "$CREDENTIALS_DIRECTORY/PHOTOPRISM_ADMIN_PASSWORD")
        ''}
        exec ${cfg.package}/bin/photoprism start
      '';
    };
  };
}
