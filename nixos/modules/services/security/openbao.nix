{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.services.openbao;
  opt = options.services.openbao;

  configFile = pkgs.writeText "openbao.hcl" ''
    # openbao in dev mode will refuse to start if its configuration sets listener
    ${lib.optionalString (!cfg.dev) ''
      listener "tcp" {
        address = "${cfg.address}"
        ${
          if (cfg.tlsCertFile == null || cfg.tlsKeyFile == null) then
            ''
              tls_disable = "true"
            ''
          else
            ''
              tls_cert_file = "${cfg.tlsCertFile}"
              tls_key_file = "${cfg.tlsKeyFile}"
            ''
        }
        ${cfg.listenerExtraConfig}
      }
    ''}
    storage "${cfg.storageBackend}" {
      ${lib.optionalString (cfg.storagePath != null) ''path = "${cfg.storagePath}"''}
      ${lib.optionalString (cfg.storageConfig != null) cfg.storageConfig}
    }
    ${lib.optionalString (cfg.telemetryConfig != "") ''
      telemetry {
        ${cfg.telemetryConfig}
      }
    ''}
    ${cfg.extraConfig}
  '';

  allConfigPaths = [ configFile ] ++ cfg.extraSettingsPaths;
  configOptions = lib.escapeShellArgs (
    lib.optional cfg.dev "-dev"
    ++ lib.optional (cfg.dev && cfg.devRootTokenID != null) "-dev-root-token-id=${cfg.devRootTokenID}"
    ++ (lib.concatMap (p: [
      "-config"
      p
    ]) allConfigPaths)
  );

in

{
  options = {
    services.openbao = {
      enable = lib.mkEnableOption "OpenBao daemon";

      package = lib.mkPackageOption pkgs "openbao" { };

      dev = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          In this mode, OpenBao runs in-memory and starts unsealed. This option is not meant production but for development and testing i.e. for nixos tests.
        '';
      };

      devRootTokenID = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Initial root token. This requires {option}`services.openbao.dev` to be set to true
        '';
      };

      address = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1:8200";
        description = "The name of the ip interface to listen to";
      };

      tlsCertFile = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "/path/to/your/cert.pem";
        description = "TLS certificate file. TLS will be disabled unless this option is set";
      };

      tlsKeyFile = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "/path/to/your/key.pem";
        description = "TLS private key file. TLS will be disabled unless this option is set";
      };

      listenerExtraConfig = lib.mkOption {
        type = lib.types.lines;
        default = ''
          tls_min_version = "tls12"
        '';
        description = "Extra text appended to the listener section.";
      };

      storageBackend = lib.mkOption {
        type = lib.types.enum [
          "inmem"
          "file"
          "consul"
          "zookeeper"
          "s3"
          "azure"
          "dynamodb"
          "etcd"
          "mssql"
          "mysql"
          "postgresql"
          "swift"
          "gcs"
          "raft"
        ];
        default = "inmem";
        description = "The name of the type of storage backend";
      };

      storagePath = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default =
          if cfg.storageBackend == "file" || cfg.storageBackend == "raft" then "/var/lib/openbao" else null;
        defaultText = lib.literalExpression ''
          if config.${opt.storageBackend} == "file" || cfg.storageBackend == "raft"
          then "/var/lib/openbao"
          else null
        '';
        description = "Data directory for file backend";
      };

      storageConfig = lib.mkOption {
        type = lib.types.nullOr lib.types.lines;
        default = null;
        description = ''
          HCL configuration to insert in the storageBackend section.

          Confidential values should not be specified here because this option's
          value is written to the Nix store, which is publicly readable.
          Provide credentials and such in a separate file using
          [](#opt-services.openbao.extraSettingsPaths).
        '';
      };

      telemetryConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Telemetry configuration";
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Extra text appended to {file}`openbao.hcl`.";
      };

      extraSettingsPaths = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        description = ''
          Configuration files to load besides the immutable one defined by the NixOS module.
          This can be used to avoid putting credentials in the Nix store, which can be read by any user.

          Each path can point to a JSON- or HCL-formatted file, or a directory
          to be scanned for files with `.hcl` or
          `.json` extensions.

          To upload the confidential file with NixOps, use for example:

          ```
          # https://releases.nixos.org/nixops/latest/manual/manual.html#opt-deployment.keys
          deployment.keys."openbao.hcl" = let db = import ./db-credentials.nix; in {
            text = ${"''"}
              storage "postgresql" {
                connection_url = "postgres://''${db.username}:''${db.password}@host.example.com/exampledb?sslmode=verify-ca"
              }
            ${"''"};
            user = "openbao";
          };
          services.openbao.extraSettingsPaths = ["/run/keys/openbao.hcl"];
          services.openbao.storageBackend = "postgresql";
          users.users.openbao.extraGroups = ["keys"];
          ```
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.openbao ];

    assertions = [
      {
        assertion = cfg.storageBackend == "inmem" -> (cfg.storagePath == null && cfg.storageConfig == null);
        message = ''The "inmem" storage expects no services.openbao.storagePath nor services.openbao.storageConfig'';
      }
      {
        assertion = (
          (cfg.storageBackend == "file" -> (cfg.storagePath != null && cfg.storageConfig == null))
          && (cfg.storagePath != null -> (cfg.storageBackend == "file" || cfg.storageBackend == "raft"))
        );
        message = ''You must set services.openbao.storagePath only when using the "file" or "raft" backend'';
      }
      {
        assertion = cfg.dev || cfg.devRootTokenID == null;
        message = "If devRootTokenID is set then dev must also be set";
      }
    ];

    users.users.openbao = {
      name = "openbao";
      group = "openbao";
      isSystemUser = true;
      description = "OpenBao daemon user";
    };
    users.groups.openbao = { };

    systemd.tmpfiles.settings = lib.mkIf (cfg.storagePath != null) {
      openbao = {
        ${cfg.storagePath} = {
          d = {
            mode = "0700";
            group = "openbao";
          };
        };
      };
    };

    systemd.services.openbao = {
      description = "OpenBao server daemon";

      wantedBy = [ "multi-user.target" ];
      after =
        [
          "network.target"
        ]
        ++ lib.optional (config.services.consul.enable && cfg.storageBackend == "consul") "consul.service";

      restartIfChanged = false; # do not restart on "nixos-rebuild switch". It would seal the storage and disrupt the clients.

      startLimitIntervalSec = 60;
      startLimitBurst = 3;
      serviceConfig = {
        User = "openbao";
        Group = "openbao";
        ExecStart = "${lib.getExe cfg.package} server ${configOptions}";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGHUP $MAINPID";
        StateDirectory = "openbao";
        # In `dev` mode openbao will put its token here
        Environment = lib.optional (cfg.dev) "HOME=/var/lib/openbao";
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectSystem = "full";
        ProtectHome = "read-only";
        AmbientCapabilities = "cap_ipc_lock";
        NoNewPrivileges = true;
        LimitCORE = 0;
        KillSignal = "SIGINT";
        TimeoutStopSec = "30s";
        Restart = "on-failure";
      };

      unitConfig.RequiresMountsFor = lib.optional (cfg.storagePath != null) cfg.storagePath;
    };
  };

}
