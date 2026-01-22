{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.matrix-tuwunel;
  defaultUser = "tuwunel";
  defaultGroup = "tuwunel";

  format = pkgs.formats.toml { };
  configFile = format.generate "tuwunel.toml" cfg.settings;
in
{
  meta.maintainers = with lib.maintainers; [
    scvalex
  ];
  options.services.matrix-tuwunel = {
    enable = lib.mkEnableOption "tuwunel";

    package = lib.mkPackageOption pkgs "matrix-tuwunel" { };

    user = lib.mkOption {
      type = lib.types.nonEmptyStr;
      description = ''
        The user {command}`tuwunel` is run as.  If left as the default, the user will
        automatically be created by the service.
      '';
      example = "conduit";
      default = defaultUser;
    };

    group = lib.mkOption {
      type = lib.types.nonEmptyStr;
      description = ''
        The group {command}`tuwunel` is run as.  If left as the default, the group will
        automatically be created by the service.
      '';
      example = "conduit";
      default = defaultGroup;
    };

    stateDirectory = lib.mkOption {
      type = lib.types.nonEmptyStr;
      default = "tuwunel";
      example = "matrix-conduit";
      description = ''
        The name of the directory under /var/lib/ where the database will be stored.

        Note that `stateDirectory` cannot be changed once created because of the service's reliance on
        systemd `StateDirectory`.
      '';
    };

    extraEnvironment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = "Extra Environment variables to pass to the tuwunel server.";
      default = { };
      example = {
        RUST_BACKTRACE = "yes";
      };
    };

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
              If set to `null`, tuwunel will listen on IPv4 and IPv6 localhost.
              Must be `null` if `unix_socket_path` is set.
            '';
          };
          global.port = lib.mkOption {
            type = lib.types.listOf lib.types.port;
            default = [ 6167 ];
            description = ''
              The port(s) tuwunel will be running on.
              You need to set up a reverse proxy in your web server (e.g. apache or nginx),
              so all requests to /_matrix on port 443 and 8448 will be forwarded to the tuwunel
              instance running on this port.
            '';
          };
          global.unix_socket_path = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            description = ''
              Listen on a UNIX socket at the specified path. If listening on a UNIX socket,
              listening on an address will be disabled. The `address` option must be set to
              `null` (the default value). The option {option}`services.tuwunel.group` must
              be set to a group your reverse proxy is part of.
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

              Currently, tuwunel doesn't support inbound batched key requests, so
              this list should only contain other Synapse servers.

              Example: `[ "matrix.org" "constellatory.net" "tchncs.de" ]`
            '';
          };
        };
      };
      default = { };
      # TOML does not allow null values, so we use null to omit those fields
      apply = lib.filterAttrsRecursive (_: v: v != null);
      description = ''
        Generates the tuwunel.toml configuration file. Refer to
        <https://matrix-construct.github.io/tuwunel/configuration.html>
        for details on supported values.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.settings ? global.unix_socket_path) || !(cfg.settings ? global.address);
        message = ''
          In `services.matrix-tuwunel.settings.global`, `unix_socket_path` and `address` cannot be set at the
          same time.
          Leave one of the two options unset or explicitly set them to `null`.
        '';
      }
      {
        assertion = cfg.user != defaultUser -> config ? users.users.${cfg.user};
        message = "If `services.matrix-tuwunel.user` is changed, the configured user must already exist.";
      }
      {
        assertion = cfg.group != defaultGroup -> config ? users.groups.${cfg.group};
        message = "If `services.matrix-tuwunel.group` is changed, the configured group must already exist.";
      }
      {
        assertion = "/var/lib/${cfg.settings.global.database_path}" != cfg.stateDirectory;
        message = "The `services.matrix-tuwunel.stateDirectory` and `services.matrix-tuwunel.settings.global.database_path` options must match.";
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

    services.matrix-tuwunel.settings.global.database_path = "/var/lib/${cfg.stateDirectory}/";

    systemd.services.tuwunel = {
      description = "Tuwunel Matrix Server";
      documentation = [ "https://matrix-construct.github.io/tuwunel/" ];
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      environment = lib.mkMerge [
        { TUWUNEL_CONFIG = configFile; }
        cfg.extraEnvironment
      ];
      startLimitBurst = 5;
      startLimitIntervalSec = 60;
      serviceConfig = {
        DynamicUser = true;
        User = cfg.user;
        Group = cfg.group;

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

        StateDirectory = cfg.stateDirectory;
        StateDirectoryMode = "0700";
        RuntimeDirectory = "tuwunel";
        RuntimeDirectoryMode = "0750";

        ExecStart = lib.getExe cfg.package;
        Restart = "on-failure";
        RestartSec = 10;
      };
    };
  };
}
