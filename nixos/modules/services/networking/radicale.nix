{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.radicale;

  format = pkgs.formats.ini {
    listToValue = lib.concatMapStringsSep ", " (lib.generators.mkValueStringDefault { });
  };

  pkg = if cfg.package == null then pkgs.radicale else cfg.package;

  confFile =
    if cfg.settings == { } then
      pkgs.writeText "radicale.conf" cfg.config
    else
      format.generate "radicale.conf" cfg.settings;

  rightsFile = format.generate "radicale.rights" cfg.rights;

  bindLocalhost = cfg.settings != { } && !lib.hasAttrByPath [ "server" "hosts" ] cfg.settings;

in
{
  options.services.radicale = {
    enable = lib.mkEnableOption "Radicale CalDAV and CardDAV server";

    package = lib.mkOption {
      description = "Radicale package to use.";
      # Default cannot be pkgs.radicale because non-null values suppress
      # warnings about incompatible configuration and storage formats.
      type = with lib.types; nullOr package // { inherit (package) description; };
      default = null;
      defaultText = lib.literalExpression "pkgs.radicale";
    };

    config = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        Radicale configuration, this will set the service
        configuration file.
        This option is mutually exclusive with {option}`settings`.
        This option is deprecated.  Use {option}`settings` instead.
      '';
    };

    settings = lib.mkOption {
      type = format.type;
      default = { };
      description = ''
        Configuration for Radicale. See
        <https://radicale.org/v3.html#configuration>.
        This option is mutually exclusive with {option}`config`.
      '';
      example = lib.literalExpression ''
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

    rights = lib.mkOption {
      type = format.type;
      description = ''
        Configuration for Radicale's rights file. See
        <https://radicale.org/v3.html#authentication-and-rights>.
        This option only works in conjunction with {option}`settings`.
        Setting this will also set {option}`settings.rights.type` and
        {option}`settings.rights.file` to appropriate values.
      '';
      default = { };
      example = lib.literalExpression ''
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

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Extra arguments passed to the Radicale daemon.";
    };
  };

  config = lib.mkIf cfg.enable {
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
      lib.optional (cfg.package == null && lib.versionOlder config.system.stateVersion "17.09") ''
        The configuration and storage formats of your existing Radicale
        installation might be incompatible with the newest version.
        For upgrade instructions see
        https://radicale.org/2.1.html#documentation/migration-from-1xx-to-2xx.
        Set services.radicale.package to suppress this warning.
      ''
      ++ lib.optional (cfg.package == null && lib.versionOlder config.system.stateVersion "20.09") ''
        The configuration format of your existing Radicale installation might be
        incompatible with the newest version.  For upgrade instructions see
        https://github.com/Kozea/Radicale/blob/3.0.6/NEWS.md#upgrade-checklist.
        Set services.radicale.package to suppress this warning.
      ''
      ++ lib.optional (cfg.config != "") ''
        The option services.radicale.config is deprecated.
        Use services.radicale.settings instead.
      '';

    services.radicale.settings.rights = lib.mkIf (cfg.rights != { }) {
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
        ExecStart = lib.concatStringsSep " " (
          [
            "${pkg}/bin/radicale"
            "-C"
            confFile
          ]
          ++ (map lib.escapeShellArg cfg.extraArgs)
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
        IPAddressAllow = lib.mkIf bindLocalhost "localhost";
        IPAddressDeny = lib.mkIf bindLocalhost "any";
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
        ReadWritePaths = lib.optional (lib.hasAttrByPath [
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
