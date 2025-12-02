{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.meilisearch;

  settingsFormat = pkgs.formats.toml { };

  # These secrets are used in the config file and can be set to paths.
  secrets-with-path =
    builtins.map
      (
        { environment, name }:
        {
          inherit name environment;
          setting = cfg.settings.${name};
        }
      )
      [
        {
          environment = "MEILI_SSL_CERT_PATH";
          name = "ssl_cert_path";
        }
        {
          environment = "MEILI_SSL_KEY_PATH";
          name = "ssl_key_path";
        }
        {
          environment = "MEILI_SSL_AUTH_PATH";
          name = "ssl_auth_path";
        }
        {
          environment = "MEILI_SSL_OCSP_PATH";
          name = "ssl_ocsp_path";
        }
      ];

  # We also handle `master_key` separately.
  # It cannot be set to a path, so we template it.
  master-key-placeholder = "@MASTER_KEY@";

  configFile = settingsFormat.generate "config.toml" (
    builtins.removeAttrs (
      if cfg.masterKeyFile != null then
        cfg.settings // { master_key = master-key-placeholder; }
      else
        builtins.removeAttrs cfg.settings [ "master_key" ]
    ) (map (secret: secret.name) secrets-with-path)
  );

in
{
  meta.maintainers = with lib.maintainers; [
    Br1ght0ne
    happysalada
  ];
  meta.doc = ./meilisearch.md;

  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "meilisearch" "environment" ]
      [ "services" "meilisearch" "settings" "env" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "meilisearch" "logLevel" ]
      [ "services" "meilisearch" "settings" "log_level" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "meilisearch" "noAnalytics" ]
      [ "services" "meilisearch" "settings" "no_analytics" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "meilisearch" "maxIndexSize" ]
      [ "services" "meilisearch" "settings" "max_index_size" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "meilisearch" "payloadSizeLimit" ]
      [ "services" "meilisearch" "settings" "http_payload_size_limit" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "meilisearch" "dumplessUpgrade" ]
      [ "services" "meilisearch" "settings" "experimental_dumpless_upgrade" ]
    )
    (lib.mkRemovedOptionModule [ "services" "meilisearch" "masterKeyEnvironmentFile" ] ''
      Use `services.meilisearch.masterKeyFile` instead. It does not require you to prefix the file with "MEILI_MASTER_KEY=".
      If you were abusing this option to set other options, you can now configure them with `services.meilisearch.settings`.
    '')
  ];

  options.services.meilisearch = {
    enable = lib.mkEnableOption "Meilisearch - a RESTful search API";

    package = lib.mkPackageOption pkgs "meilisearch" {
      extraDescription = ''
        Use this if you require specific features to be enabled. The default package has no features.
      '';
    };

    listenAddress = lib.mkOption {
      default = "localhost";
      type = lib.types.str;
      description = ''
        The IP address that Meilisearch will listen on.

        It can also be a hostname like "localhost". If it resolves to an IPv4 and IPv6 address, Meilisearch will listen on both.
      '';
    };

    listenPort = lib.mkOption {
      default = 7700;
      type = lib.types.port;
      description = ''
        The port that Meilisearch will listen on.
      '';
    };

    masterKeyFile = lib.mkOption {
      description = ''
        Path to file which contains the master key.
        By doing so, all routes will be protected and will require a key to be accessed.
        If no master key is provided, all routes can be accessed without requiring any key.
      '';
      default = null;
      type = lib.types.nullOr lib.types.path;
    };

    settings = lib.mkOption {
      description = ''
        Configuration settings for Meilisearch.
        Look at the documentation for available options:
        https://github.com/meilisearch/meilisearch/blob/main/config.toml
        https://www.meilisearch.com/docs/learn/self_hosted/configure_meilisearch_at_launch#all-instance-options
      '';

      default = { };

      type = lib.types.submodule {
        freeformType = settingsFormat.type;

        imports = builtins.map (secret: {
          # give them proper types, just so they're easier to consume from this file
          options.${secret.name} = lib.mkOption {
            # but they should not show up in documentation as special in any way.
            visible = false;

            type = lib.types.nullOr lib.types.path;
            default = null;
          };
        }) secrets-with-path;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !cfg.settings ? master_key;
        message = ''
          Do not set `services.meilisearch.settings.master_key` in your configuration.
          Use `services.meilisearch.masterKeyFile` instead.
        '';
      }
    ];

    services.meilisearch.settings = {
      # we use `listenAddress` and `listenPort` to derive the `http_addr` setting.
      # this is the only setting we treat like this.
      # we do this because some dependent services like Misskey/Sharkey need separate host,port for no good reason.
      http_addr = "${cfg.listenAddress}:${toString cfg.listenPort}";

      # upstream's default for `db_path` is `/var/lib/meilisearch/data.ms/`, but ours is different for no reason.
      db_path = lib.mkDefault "/var/lib/meilisearch";
      # these are equivalent to the upstream defaults, because we set a working directory.
      # they are only set here for consistency with `db_path`.
      dump_dir = lib.mkDefault "/var/lib/meilisearch/dumps";
      snapshot_dir = lib.mkDefault "/var/lib/meilisearch/snapshots";

      # this is intentionally different from upstream's default.
      no_analytics = lib.mkDefault true;
    };

    # used to restore dumps
    environment.systemPackages = [ cfg.package ];

    systemd.services.meilisearch = {
      description = "Meilisearch daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      preStart = lib.mkMerge [
        ''
          install -m 700 '${configFile}' "$RUNTIME_DIRECTORY/config.toml"
        ''
        (lib.mkIf (cfg.masterKeyFile != null) ''
          ${lib.getExe pkgs.replace-secret} '${master-key-placeholder}' "$CREDENTIALS_DIRECTORY/master_key" "$RUNTIME_DIRECTORY/config.toml"
        '')
      ];

      environment = builtins.listToAttrs (
        builtins.map (secret: {
          name = secret.environment;
          value = lib.mkIf (secret.setting != null) "%d/${secret.name}";
        }) secrets-with-path
      );

      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        Restart = "always";
        LoadCredential = lib.mkMerge (
          [
            (lib.mkIf (cfg.masterKeyFile != null) [ "master_key:${cfg.masterKeyFile}" ])
          ]
          ++ builtins.map (
            secret: lib.mkIf (secret.setting != null) [ "${secret.name}:${secret.setting}" ]
          ) secrets-with-path
        );
        ExecStart = "${lib.getExe cfg.package} --config-file-path \${RUNTIME_DIRECTORY}/config.toml";
        StateDirectory = "meilisearch";
        WorkingDirectory = "%S/meilisearch";
        RuntimeDirectory = "meilisearch";
        RuntimeDirectoryMode = "0700";
        ReadWritePaths = [
          cfg.settings.db_path
          cfg.settings.dump_dir
          cfg.settings.snapshot_dir
        ];

        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectClock = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        PrivateTmp = true;
        PrivateMounts = true;
        PrivateUsers = true;
        PrivateDevices = true;
        RestrictRealtime = true;
        RestrictNamespaces = true;
        RestrictSUIDSGID = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RemoveIPC = true;

        # Meilisearch needs to determine cgroup memory limits to set its own memory limits.
        # This means this can't be set to "pid"
        ProcSubset = "all";
        ProtectProc = "invisible";

        NoNewPrivileges = true;

        # Meilisearch does not support listening on AF_UNIX sockets,
        # so we currently restrict it to only AF_INET and AF_INET6.
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];

        CapabilityBoundingSet = "";
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged @resources"
        ];

        UMask = "0077";
      };
    };
  };
}
