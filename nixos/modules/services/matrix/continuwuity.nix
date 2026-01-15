{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.matrix-continuwuity;
  defaultUser = "continuwuity";
  defaultGroup = "continuwuity";

  format = pkgs.formats.toml { };
  configFile = format.generate "continuwuity.toml" cfg.settings;
in
{
  meta.maintainers = with lib.maintainers; [
    nyabinary
    snaki
  ];
  options.services.matrix-continuwuity = {
    enable = lib.mkEnableOption "continuwuity";

    user = lib.mkOption {
      type = lib.types.nonEmptyStr;
      description = ''
        The user {command}`continuwuity` is run as.
      '';
      default = defaultUser;
    };

    group = lib.mkOption {
      type = lib.types.nonEmptyStr;
      description = ''
        The group {command}`continuwuity` is run as.
      '';
      default = defaultGroup;
    };

    extraEnvironment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = "Extra Environment variables to pass to the continuwuity server.";
      default = { };
      example = {
        RUST_BACKTRACE = "yes";
      };
    };

    package = lib.mkPackageOption pkgs "matrix-continuwuity" { };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = format.type;
        options = {
          global.server_name = lib.mkOption {
            type = lib.types.nonEmptyStr;
            example = "example.com";
            description = "The server_name is the name of this server. It is used as a suffix for user and room ids.";
          };
          global.address = lib.mkOption {
            type = lib.types.nullOr (lib.types.listOf lib.types.nonEmptyStr);
            default = null;
            example = [
              "127.0.0.1"
              "::1"
            ];
            description = ''
              Addresses (IPv4 or IPv6) to listen on for connections by the reverse proxy/tls terminator.
              If set to `null`, continuwuity will listen on IPv4 and IPv6 localhost.
              Must be `null` if `unix_socket_path` is set.
            '';
          };
          global.port = lib.mkOption {
            type = lib.types.listOf lib.types.port;
            default = [ 6167 ];
            description = ''
              The port(s) continuwuity will be running on.
              You need to set up a reverse proxy in your web server (e.g. apache or nginx),
              so all requests to /_matrix on port 443 and 8448 will be forwarded to the continuwuity
              instance running on this port.
            '';
          };
          global.unix_socket_path = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            description = ''
              Listen on a UNIX socket at the specified path. If listening on a UNIX socket,
              listening on an address will be disabled. The `address` option must be set to
              `null` (the default value). The option {option}`services.continuwuity.group` must
              be set to a group your reverse proxy is part of.

              This will automatically add a system user "continuwuity" to your system if
              {option}`services.continuwuity.user` is left at the default, and a "continuwuity"
              group if {option}`services.continuwuity.group` is left at the default.
            '';
          };
          global.unix_socket_perms = lib.mkOption {
            type = lib.types.ints.positive;
            default = 660;
            description = "The default permissions (in octal) to create the UNIX socket with.";
          };
          global.max_request_size = lib.mkOption {
            type = lib.types.ints.positive;
            default = 20000000;
            description = "Max request size in bytes. Don't forget to also change it in the proxy.";
          };
          global.allow_registration = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = ''
              Whether new users can register on this server.

              Registration with token requires `registration_token` or `registration_token_file` to be set.

              If set to true without a token configured, and
              `yes_i_am_very_very_sure_i_want_an_open_registration_server_prone_to_abuse`
              is set to true, users can freely register.
            '';
          };
          global.allow_encryption = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether new encrypted rooms can be created. Note: existing rooms will continue to work.";
          };
          global.allow_federation = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = ''
              Whether this server federates with other servers.
            '';
          };
          global.trusted_servers = lib.mkOption {
            type = lib.types.listOf lib.types.nonEmptyStr;
            default = [ "matrix.org" ];
            description = ''
              Servers listed here will be used to gather public keys of other servers
              (notary trusted key servers).

              Currently, continuwuity doesn't support inbound batched key requests, so
              this list should only contain other Synapse servers.

              Example: `[ "matrix.org" "constellatory.net" "tchncs.de" ]`
            '';
          };
          global.database_path = lib.mkOption {
            readOnly = true;
            type = lib.types.path;
            default = "/var/lib/continuwuity/";
            description = ''
              Path to the continuwuity database, the directory where continuwuity will save its data.
              Note that database_path cannot be edited because of the service's reliance on systemd StateDir.
            '';
          };
          global.allow_announcements_check = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = ''
              If enabled, continuwuity will send a simple GET request periodically to
              <https://continuwuity.org/.well-known/continuwuity/announcements> for any new announcements made.
            '';
          };
        };
      };
      default = { };
      # TOML does not allow null values, so we use null to omit those fields
      apply = lib.filterAttrsRecursive (_: v: v != null);
      description = ''
        Generates the continuwuity.toml configuration file. Refer to
        <https://continuwuity.org/configuration.html>
        for details on supported values.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.settings ? global.unix_socket_path) || !(cfg.settings ? global.address);
        message = ''
          In `services.continuwuity.settings.global`, `unix_socket_path` and `address` cannot be set at the
          same time.
          Leave one of the two options unset or explicitly set them to `null`.
        '';
      }
      {
        assertion = cfg.user != defaultUser -> config ? users.users.${cfg.user};
        message = "If `services.continuwuity.user` is changed, the configured user must already exist.";
      }
      {
        assertion = cfg.group != defaultGroup -> config ? users.groups.${cfg.group};
        message = "If `services.continuwuity.group` is changed, the configured group must already exist.";
      }
    ];

    users.users = lib.mkIf (cfg.user == defaultUser) {
      ${defaultUser} = {
        group = cfg.group;
        home = cfg.settings.global.database_path;
        isSystemUser = true;
      };
    };

    users.groups = lib.mkIf (cfg.group == defaultGroup) {
      ${defaultGroup} = { };
    };

    systemd.services.continuwuity = {
      description = "Continuwuity Matrix Server";
      documentation = [ "https://continuwuity.org/" ];
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      environment = lib.mkMerge [
        { CONTINUWUITY_CONFIG = configFile; }
        cfg.extraEnvironment
      ];
      startLimitBurst = 5;
      startLimitIntervalSec = 60;
      serviceConfig = {
        DynamicUser = true;
        User = cfg.user;
        Group = cfg.group;

        # To avoid timing out during database migrations
        TimeoutStartSec = "10m";

        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        PrivateIPC = true;
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service @resources"
          "~@clock @debug @module @mount @reboot @swap @cpu-emulation @obsolete @timer @chown @setuid @privileged @keyring @ipc"
        ];
        SystemCallErrorNumber = "EPERM";

        StateDirectory = "continuwuity";
        StateDirectoryMode = "0700";
        RuntimeDirectory = "continuwuity";
        RuntimeDirectoryMode = "0750";

        ExecStart = lib.getExe cfg.package;
        Restart = "on-failure";
        RestartSec = 10;
      };
    };
  };
}
