{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.vault;

  configFile = pkgs.writeText "vault.hcl" ''
    listener "tcp" {
      address = "${cfg.address}"
      ${if (cfg.tlsCertFile == null || cfg.tlsKeyFile == null) then ''
          tls_disable = "true"
        '' else ''
          tls_cert_file = "${cfg.tlsCertFile}"
          tls_key_file = "${cfg.tlsKeyFile}"
        ''}
      ${cfg.listenerExtraConfig}
    }
    storage "${cfg.storageBackend}" {
      ${optionalString (cfg.storagePath   != null) ''path = "${cfg.storagePath}"''}
      ${optionalString (cfg.storageConfig != null) cfg.storageConfig}
    }
    ${optionalString (cfg.telemetryConfig != "") ''
        telemetry {
          ${cfg.telemetryConfig}
        }
      ''}
    ${cfg.extraConfig}
  '';

  allConfigPaths = [configFile] ++ cfg.extraSettingsPaths;

  configOptions = escapeShellArgs (concatMap (p: ["-config" p]) allConfigPaths);

in

{
  options = {
    services.vault = {
      enable = mkEnableOption "Vault daemon";

      package = mkOption {
        type = types.package;
        default = pkgs.vault;
        defaultText = "pkgs.vault";
        description = "This option specifies the vault package to use.";
      };

      address = mkOption {
        type = types.str;
        default = "127.0.0.1:8200";
        description = "The name of the ip interface to listen to";
      };

      tlsCertFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/path/to/your/cert.pem";
        description = "TLS certificate file. TLS will be disabled unless this option is set";
      };

      tlsKeyFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/path/to/your/key.pem";
        description = "TLS private key file. TLS will be disabled unless this option is set";
      };

      listenerExtraConfig = mkOption {
        type = types.lines;
        default = ''
          tls_min_version = "tls12"
        '';
        description = "Extra text appended to the listener section.";
      };

      storageBackend = mkOption {
        type = types.enum [ "inmem" "file" "consul" "zookeeper" "s3" "azure" "dynamodb" "etcd" "mssql" "mysql" "postgresql" "swift" "gcs" "raft" ];
        default = "inmem";
        description = "The name of the type of storage backend";
      };

      storagePath = mkOption {
        type = types.nullOr types.path;
        default = if cfg.storageBackend == "file" then "/var/lib/vault" else null;
        description = "Data directory for file backend";
      };

      storageConfig = mkOption {
        type = types.nullOr types.lines;
        default = null;
        description = ''
          HCL configuration to insert in the storageBackend section.

          Confidential values should not be specified here because this option's
          value is written to the Nix store, which is publicly readable.
          Provide credentials and such in a separate file using
          <xref linkend="opt-services.vault.extraSettingsPaths"/>.
        '';
      };

      telemetryConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Telemetry configuration";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Extra text appended to <filename>vault.hcl</filename>.";
      };

      extraSettingsPaths = mkOption {
        type = types.listOf types.path;
        default = [];
        description = ''
          Configuration files to load besides the immutable one defined by the NixOS module.
          This can be used to avoid putting credentials in the Nix store, which can be read by any user.

          Each path can point to a JSON- or HCL-formatted file, or a directory
          to be scanned for files with <literal>.hcl</literal> or
          <literal>.json</literal> extensions.

          To upload the confidential file with NixOps, use for example:

          <programlisting><![CDATA[
          # https://releases.nixos.org/nixops/latest/manual/manual.html#opt-deployment.keys
          deployment.keys."vault.hcl" = let db = import ./db-credentials.nix; in {
            text = ${"''"}
              storage "postgresql" {
                connection_url = "postgres://''${db.username}:''${db.password}@host.example.com/exampledb?sslmode=verify-ca"
              }
            ${"''"};
            user = "vault";
          };
          services.vault.extraSettingsPaths = ["/run/keys/vault.hcl"];
          services.vault.storageBackend = "postgresql";
          users.users.vault.extraGroups = ["keys"];
          ]]></programlisting>
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      { assertion = cfg.storageBackend == "inmem" -> (cfg.storagePath == null && cfg.storageConfig == null);
        message = ''The "inmem" storage expects no services.vault.storagePath nor services.vault.storageConfig'';
      }
      { assertion = (cfg.storageBackend == "file" -> (cfg.storagePath != null && cfg.storageConfig == null)) && (cfg.storagePath != null -> cfg.storageBackend == "file");
        message = ''You must set services.vault.storagePath only when using the "file" backend'';
      }
    ];

    users.users.vault = {
      name = "vault";
      group = "vault";
      uid = config.ids.uids.vault;
      description = "Vault daemon user";
    };
    users.groups.vault.gid = config.ids.gids.vault;

    systemd.tmpfiles.rules = optional (cfg.storagePath != null)
      "d '${cfg.storagePath}' 0700 vault vault - -";

    systemd.services.vault = {
      description = "Vault server daemon";

      wantedBy = ["multi-user.target"];
      after = [ "network.target" ]
           ++ optional (config.services.consul.enable && cfg.storageBackend == "consul") "consul.service";

      restartIfChanged = false; # do not restart on "nixos-rebuild switch". It would seal the storage and disrupt the clients.

      startLimitIntervalSec = 60;
      startLimitBurst = 3;
      serviceConfig = {
        User = "vault";
        Group = "vault";
        ExecStart = "${cfg.package}/bin/vault server ${configOptions}";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGHUP $MAINPID";
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectSystem = "full";
        ProtectHome = "read-only";
        AmbientCapabilities = "cap_ipc_lock";
        NoNewPrivileges = true;
        KillSignal = "SIGINT";
        TimeoutStopSec = "30s";
        Restart = "on-failure";
      };

      unitConfig.RequiresMountsFor = optional (cfg.storagePath != null) cfg.storagePath;
    };
  };

}
