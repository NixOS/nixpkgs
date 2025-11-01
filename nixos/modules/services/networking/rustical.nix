{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    getExe
    maintainers
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    ;

  inherit (lib.types)
    attrsOf
    bool
    either
    int
    nullOr
    path
    port
    str
    submodule
    ;

  cfg = config.services.rustical;
  settingsFormat = pkgs.formats.toml { };
in
{
  options.services.rustical = {
    enable = mkEnableOption "Rustical CalDAV and CardDAV server";
    package = mkPackageOption pkgs "rustical" { };
    settings = mkOption {
      type = submodule {
        freeformType = settingsFormat.type;
        options.http.port = mkOption {
          type = port;
          default = 4000;
          description = ''
            Which port this service should listen on.
          '';
        };
      };
      default = { };
      description = ''
        Configuration for Rustical, written as TOML

        Refer to the [documentation](https://lennart-k.github.io/rustical/installation/configuration) for options.
      '';
    };
    environmentFile = mkOption {
      type = nullOr path;
      default = null;
      example = "/run/secrets/rustical";
      description = ''
        An environment file as defined in {manpage}`systemd.exec(5)`.

        Use this to inject secrets, e.g. database or auth credentials out of band.

        Refer to the [documentation](https://lennart-k.github.io/rustical/installation/configuration/#environment-variables) for options.
      '';
    };
    environment = mkOption {
      type = attrsOf (either int str);
      default = { };
      description = ''
        Environment variables passed to the service. Any config option name prefixed with RUSTICAL_ takes priority over the one in the configuration file.
      '';
      example = {
        RUSTICAL_HTTP__PORT = 4000;
      };
    };
    dataDir = mkOption {
      type = path;
      default = "/var/lib/rustical";
      description = "The state directory for Rustical";
    };
    openFirewall = lib.mkOption {
      type = bool;
      default = false;
      description = "Open ports in the firewall for the Rustical.";
    };
    user = mkOption {
      type = str;
      default = "rustical";
      description = "User under which the rustical service runs.";
    };
    group = mkOption {
      type = str;
      default = "rustical";
      description = "Group under which the rustical service runs.";
    };
  };

  config = mkIf cfg.enable {
    services.rustical.settings = {
      # We assume dataDir is used, so we require this value,
      # therefore no mkDefault
      data_store.sqlite.db_url = "${cfg.dataDir}/db.sqlite3";
      http.host = mkDefault "0.0.0.0";
      frontend = {
        enabled = mkDefault true;
        allow_password_login = mkDefault true;
      };
      tracing.opentelemetry = mkDefault false;
      dav_push.enabled = mkDefault true;
      nextcloud_login.enabled = mkDefault true;
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.settings.http.port ];
    };

    users = {
      users.${cfg.user} = {
        isSystemUser = true;
        group = cfg.group;
      };
      groups.${cfg.group} = { };
    };

    systemd = {
      services.rustical = {
        description = "A CalDAV/CardDAV server";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        environment = cfg.environment;
        serviceConfig = {
          Type = "simple";
          ExecStart = "${getExe cfg.package} --config-file ${settingsFormat.generate "config.toml" cfg.settings}";
          EnvironmentFile = mkIf (cfg.environmentFile != null) cfg.environmentFile;
          StateDirectory = mkIf (cfg.dataDir == "/var/lib/rustical") "rustical";
          User = cfg.user;
          Group = cfg.group;
          Restart = "on-failure";
          # Hardening
          SystemCallFilter = "@system-service";
          SystemCallErrorNumber = "EPERM";
          ProtectSystem = "strict";
          ProtectHome = "yes";
          ProtectKernelTunables = "yes";
          ProtectKernelModules = "yes";
          ProtectControlGroups = "yes";
          ProtectProc = "invisible";
          ProcSubset = "pid";
          CapabilityBoundingSet = "";
          AmbientCapabilities = "";
          PrivateDevices = "yes";
          PrivateTmp = "yes";
          NoNewPrivileges = "yes";
          ReadWritePaths = cfg.dataDir;
          ProtectHostname = "yes";
          ProtectClock = "yes";
        };
      };
      tmpfiles.settings.rustical."${cfg.dataDir}".d = mkIf (cfg.dataDir != "/var/lib/rustical") {
        inherit (cfg) user group;

        mode = "0755";
      };
    };
  };

  meta.maintainers = with maintainers; [ PopeRigby ];
}
