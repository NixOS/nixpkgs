{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.vault;

  configFile = pkgs.writeText "vault.hcl" ''
    listener "tcp" {
      address = "${cfg.address}"
      tls_cert_file = "${cfg.tlsCertFile}"
      tls_key_file = "${cfg.tlsKeyFile}"
      ${cfg.listenerExtraConfig}
    }
    storage "${cfg.storageBackend}" {
      ${cfg.storageConfig}
    }
    ${optionalString (cfg.telemetryConfig != "") ''
        telemetry {
          ${cfg.telemetryConfig}
        }
      ''}
  '';
in
{
  options = {

    services.vault = {

      enable = mkEnableOption "Vault daemon";

      address = mkOption {
        type = types.str;
        default = "127.0.0.1:8200";
        description = "The name of the ip interface to listen to";
      };

      tlsCertFile = mkOption {
        type = types.str;
        default = "/etc/vault/cert.pem";
        example = "/path/to/your/cert.pem";
        description = "TLS certificate file. A self-signed certificate will be generated if file not exists";
      };

      tlsKeyFile = mkOption {
        type = types.str;
        default = "/etc/vault/key.pem";
        example = "/path/to/your/key.pem";
        description = "TLS private key file. A self-signed certificate will be generated if file not exists";
      };

      listenerExtraConfig = mkOption {
        type = types.lines;
        default = ''
          tls_min_version = "tls12"
        '';
        description = "extra configuration";
      };

      storageBackend = mkOption {
        type = types.enum ["inmem" "consul" "zookeeper" "file" "s3" "azure" "dynamodb" "etcd" "mssql" "mysql" "postgresql" "swift" "gcs"];
        default = "inmem";
        description = "The name of the type of storage backend";
      };

      storageConfig = mkOption {
        type = types.lines;
        description = "Storage configuration";
        default = "";
      };

      telemetryConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Telemetry configuration";
      };
    };
  };

  config = mkIf cfg.enable {

    users.extraUsers.vault = {
      name = "vault";
      group = "vault";
      uid = config.ids.uids.vault;
      description = "Vault daemon user";
    };
    users.extraGroups.vault.gid = config.ids.gids.vault;

    systemd.services.vault = {
      description = "Vault server daemon";

      wantedBy = ["multi-user.target"];
      after = [ "network.target" ];

      preStart = ''
        mkdir -m 0755 -p /var/lib/vault
        chown -R vault:vault /var/lib/vault

        # generate a self-signed certificate, you will have to set environment variable "VAULT_SKIP_VERIFY=1" in the client
        if [ ! -s ${cfg.tlsCertFile} -o ! -s ${cfg.tlsKeyFile} ]; then
          mkdir -p $(dirname ${cfg.tlsCertFile}) || true
          mkdir -p $(dirname ${cfg.tlsKeyFile }) || true
          ${pkgs.openssl.bin}/bin/openssl req -x509 -newkey rsa:2048 -sha256 -nodes -days 99999 \
            -subj /C=US/ST=NY/L=NYC/O=vault/CN=${cfg.address} \
            -keyout ${cfg.tlsKeyFile} -out ${cfg.tlsCertFile}

          chown root:vault ${cfg.tlsKeyFile} ${cfg.tlsCertFile}
          chmod 440 ${cfg.tlsKeyFile} ${cfg.tlsCertFile}
        fi
      '';

      serviceConfig = {
        User = "vault";
        Group = "vault";
        PermissionsStartOnly = true;
        ExecStart = "${pkgs.vault}/bin/vault server -config ${configFile}";
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectSystem = "full";
        ProtectHome = "read-only";
        AmbientCapabilities = "cap_ipc_lock";
        NoNewPrivileges = true;
        KillSignal = "SIGINT";
        TimeoutStopSec = "30s";
        Restart = "on-failure";
        StartLimitInterval = "60s";
        StartLimitBurst = 3;
      };
    };
  };

}
