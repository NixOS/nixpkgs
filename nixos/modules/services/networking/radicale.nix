{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.radicale;

  format = pkgs.formats.ini {
    listToValue = concatMapStringsSep ", " (generators.mkValueStringDefault { });
  };

  pkg = if cfg.package == null then pkgs.radicale else cfg.package;

  confFile =
    if cfg.settings == { } then
      pkgs.writeText "radicale.conf" cfg.config
    else
      format.generate "radicale.conf" cfg.settings;

  rightsFile = format.generate "radicale.rights" cfg.rights;

  bindLocalhost =
    cfg.settings != { }
    && !hasAttrByPath [
      "server"
      "hosts"
    ] cfg.settings;

in
{
  options.services.radicale = {
    enable = mkEnableOption "Radicale CalDAV and CardDAV server";

    package = mkOption {
      description = "Radicale package to use.";
      # Default cannot be pkgs.radicale because non-null values suppress
      # warnings about incompatible configuration and storage formats.
      type = with types; nullOr package // { inherit (package) description; };
      default = null;
      defaultText = literalExpression "pkgs.radicale";
    };

    config = mkOption {
      type = types.str;
      default = "";
      description = ''
        Radicale configuration, this will set the service
        configuration file.
        This option is mutually exclusive with {option}`settings`.
        This option is deprecated.  Use {option}`settings` instead.
      '';
    };

    settings = mkOption {
      type = format.type;
      default = { };
      description = ''
        Configuration for Radicale. See
        <https://radicale.org/3.0.html#documentation/configuration>.
        This option is mutually exclusive with {option}`config`.
      '';
      example = literalExpression ''
        server = {
          hosts = [ "0.0.0.0:5232" "[::]:5232" ];
        };
        auth = {
          type = "htpasswd";
          htpasswd_filename = "/etc/radicale/users";
          htpasswd_encryption = "bcrypt";
        };
        storage = {
          filesystem_folder = "/var/lib/radicale/collections";
        };
      '';
    };

    rights = mkOption {
      type = format.type;
      description = ''
        Configuration for Radicale's rights file. See
        <https://radicale.org/3.0.html#documentation/authentication-and-rights>.
        This option only works in conjunction with {option}`settings`.
        Setting this will also set {option}`settings.rights.type` and
        {option}`settings.rights.file` to appropriate values.
      '';
      default = { };
      example = literalExpression ''
        root = {
          user = ".+";
          collection = "";
          permissions = "R";
        };
        principal = {
          user = ".+";
          collection = "{user}";
          permissions = "RW";
        };
        calendars = {
          user = ".+";
          collection = "{user}/[^/]+";
          permissions = "rw";
        };
      '';
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Extra arguments passed to the Radicale daemon.";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.settings == { } || cfg.config == "";
        message = ''
          The options services.radicale.config and services.radicale.settings
          are mutually exclusive.
        '';
      }
    ];

    warnings =
      optional (cfg.package == null && versionOlder config.system.stateVersion "17.09") ''
        The configuration and storage formats of your existing Radicale
        installation might be incompatible with the newest version.
        For upgrade instructions see
        https://radicale.org/2.1.html#documentation/migration-from-1xx-to-2xx.
        Set services.radicale.package to suppress this warning.
      ''
      ++ optional (cfg.package == null && versionOlder config.system.stateVersion "20.09") ''
        The configuration format of your existing Radicale installation might be
        incompatible with the newest version.  For upgrade instructions see
        https://github.com/Kozea/Radicale/blob/3.0.6/NEWS.md#upgrade-checklist.
        Set services.radicale.package to suppress this warning.
      ''
      ++ optional (cfg.config != "") ''
        The option services.radicale.config is deprecated.
        Use services.radicale.settings instead.
      '';

    services.radicale.settings.rights = mkIf (cfg.rights != { }) {
      type = "from_file";
      file = toString rightsFile;
    };

    environment.systemPackages = [ pkg ];

    users.users.radicale = {
      isSystemUser = true;
      group = "radicale";
    };

    users.groups.radicale = { };

    systemd.services.radicale = {
      description = "A Simple Calendar and Contact Server";
      after = [ "network.target" ];
      requires = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = concatStringsSep " " (
          [
            "${pkg}/bin/radicale"
            "-C"
            confFile
          ]
          ++ (map escapeShellArg cfg.extraArgs)
        );
        User = "radicale";
        Group = "radicale";
        StateDirectory = "radicale/collections";
        StateDirectoryMode = "0750";
        # Hardening
        CapabilityBoundingSet = [ "" ];
        DeviceAllow = [
          "/dev/stdin"
          "/dev/urandom"
        ];
        DevicePolicy = "strict";
        IPAddressAllow = mkIf bindLocalhost "localhost";
        IPAddressDeny = mkIf bindLocalhost "any";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        ReadWritePaths = lib.optional (hasAttrByPath [
          "storage"
          "filesystem_folder"
        ] cfg.settings) cfg.settings.storage.filesystem_folder;
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        UMask = "0027";
        WorkingDirectory = "/var/lib/radicale";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ dotlambda ];
}
