{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.cfssl;

  csrCA = pkgs.writeText "cfssl-cacert-csr.json" (builtins.toJSON cfg.initca.csr);
  csrCfssl = pkgs.writeText "cfssl-cert-csr.json" (builtins.toJSON cfg.initssl.csr);

  # list of auth keys that require generation
  generateAuthKeys =
    filterAttrs (_: key: key.enable && key.generate) cfg.configuration.authKeys;

in {
  options.services.cfssl = {
    enable = mkEnableOption "the CFSSL CA api-server";

    dataDir = mkOption {
      default = "/var/lib/cfssl";
      type = types.path;
      description = "Cfssl work directory.";
    };

    address = mkOption {
      default = "127.0.0.1";
      type = types.str;
      description = "Address to bind.";
    };

    port = mkOption {
      default = 8888;
      type = types.ints.u16;
      description = "Port to bind.";
    };

    ca = mkOption {
      defaultText = "\${cfg.dataDir}/ca.pem";
      type = types.str;
      description = "CA used to sign the new certificate -- accepts '[file:]fname' or 'env:varname'.";
    };

    caKey = mkOption {
      defaultText = "file:\${cfg.dataDir}/ca-key.pem";
      type = types.str;
      description = "CA private key -- accepts '[file:]fname' or 'env:varname'.";
    };

    caBundle = mkOption {
      default = null;
      type = types.nullOr types.path;
      description = "Path to root certificate store.";
    };

    intBundle = mkOption {
      default = null;
      type = types.nullOr types.path;
      description = "Path to intermediate certificate store.";
    };

    intDir = mkOption {
      default = null;
      type = types.nullOr types.path;
      description = "Intermediates directory.";
    };

    metadata = mkOption {
      default = null;
      type = types.nullOr types.path;
      description = ''
        Metadata file for root certificate presence.
        The content of the file is a json dictionary (k,v): each key k is
        a SHA-1 digest of a root certificate while value v is a list of key
        store filenames.
      '';
    };

    remote = mkOption {
      default = null;
      type = types.nullOr types.str;
      description = "Remote CFSSL server.";
    };

    configFile = mkOption {
      default = null;
      type = types.nullOr types.path;
      description = "Path to configuration file. Do not put this in nix-store as it might contain secrets.";
    };

    configuration = mkOption {
      default = {};
      type = types.submodule {
        imports = [ ./cfssl-config.nix ];

        options = {
          authKeys = mkOption {
            type = types.attrsOf (types.submodule ({ config, ... }:{
              options = {
                generate = mkOption {
                  description = "Whether to automatically generate auth key";
                  type = types.bool;
                  default = false;
                };

                length = mkOption {
                  description = "Generated auth key length";
                  type = types.int;
                  default = 22;
                };

                file = mkOption {
                  description = "Auth key file path.";
                  type = types.nullOr types.path;
                  default =
                    if config.generate
                    then "${cfg.dataDir}/${config.name}-key.secret" else null;
                };
              };

              config = mkIf (config.file != null) {
                key = "file:${config.file}";
              };
            }));
          };
        };
      };
      description = "CFSSL configuration.";
    };

    responder = mkOption {
      default = null;
      type = types.nullOr types.path;
      description = "Certificate for OCSP responder.";
    };

    responderKey = mkOption {
      default = null;
      type = types.nullOr types.str;
      description = "Private key for OCSP responder certificate. Do not put this in nix-store.";
    };

    tlsKey = mkOption {
      default = null;
      type = types.nullOr types.str;
      description = "Other endpoint's CA private key. Do not put this in nix-store.";
    };

    tlsCert = mkOption {
      default = null;
      type = types.nullOr types.path;
      description = "Other endpoint's CA to set up TLS protocol.";
    };

    mutualTlsCa = mkOption {
      default = null;
      type = types.nullOr types.path;
      description = "Mutual TLS - require clients be signed by this CA.";
    };

    mutualTlsCn = mkOption {
      default = null;
      type = types.nullOr types.str;
      description = "Mutual TLS - regex for whitelist of allowed client CNs.";
    };

    tlsRemoteCa = mkOption {
      default = null;
      type = types.nullOr types.path;
      description = "CAs to trust for remote TLS requests.";
    };

    mutualTlsClientCert = mkOption {
      default = null;
      type = types.nullOr types.path;
      description = "Mutual TLS - client certificate to call remote instance requiring client certs.";
    };

    mutualTlsClientKey = mkOption {
      default = null;
      type = types.nullOr types.path;
      description = "Mutual TLS - client key to call remote instance requiring client certs. Do not put this in nix-store.";
    };

    dbConfig = mkOption {
      default = null;
      type = types.nullOr types.path;
      description = "Certificate db configuration file. Path must be writeable.";
    };

    initca = {
      enable = mkOption {
        default = true;
        type = types.bool;
        description = ''
          Whether to automatically generate cfssl CA certificate and key,
          if they don't exist.
        '';
      };

      csr = mkOption {
        description = "CSR spec for cfssl CA cert.";
        type = types.attrs;
        default = {
          key = {
            algo = "rsa";
            size = 2048;
          };
          names = singleton {
            CN = "CA";
            O = "NixOS";
            L = "auto-generated";
          };
        };
      };
    };

    initssl = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to automatically generate cfssl API webserver TLS cert and key,
          if they don't exist.
        '';
      };

      csr = mkOption {
        description = "CSR spec for cfssl API cert.";
        type = types.attrs;
        default = {
          key = {
            algo = "rsa";
            size = 2048;
          };
          CN = "cfssl";
          hosts = [ cfg.address ];
        };
      };
    };

    logLevel = mkOption {
      default = 1;
      type = types.enum [ 0 1 2 3 4 5 ];
      description = "Log level (0 = DEBUG, 5 = FATAL).";
    };
  };

  config = mkIf cfg.enable {
    users.extraGroups.cfssl = {
      gid = config.ids.gids.cfssl;
    };

    users.extraUsers.cfssl = {
      description = "cfssl user";
      createHome = true;
      home = cfg.dataDir;
      group = "cfssl";
      uid = config.ids.uids.cfssl;
    };

    systemd.services.cfssl-bootstrap = mkIf (cfg.initca.enable || cfs.initssl.enable || generateAuthKeys != {}) {
      description = "Kubernetes CFSSL bootstrap";
      wantedBy = [ "cfssl.service" ];
      before = [ "cfssl.service" ];
      path = [ pkgs.cfssl ];
      script = ''
        ${optionalString cfg.initca.enable ''
        if [ ! -f "${cfg.ca}" ]; then
          cfssl genkey -initca ${csrCA} | \
            cfssljson -bare ${cfg.dataDir}/ca
        fi
        ''}

        ${optionalString cfg.initssl.enable ''
          if [ ! -f "${cfg.tlsCert}" ]; then
            cfssl gencert -ca "${cfg.ca}" -ca-key "${cfg.caKey}" ${csrCfssl} | \
              cfssljson -bare ${cfg.dataDir}/cfssl
          fi
        ''}

        ${concatMapStrings (key: ''
          if [ ! -f "${key.file}" ]; then
            head -c ${toString (key.length / 2)} /dev/urandom | \
              od -An -t x | tr -d ' ' > "${key.file}"
          fi
        '') (attrValues generateAuthKeys)}
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "cfssl";
      };
    };

    systemd.services.cfssl = {
      description = "CFSSL CA API server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = [ pkgs.curl ];

      postStart = let
        remote = "${if cfg.tlsCert != null then "https" else "http"}://${cfg.address}:${toString cfg.port}";
      in ''
        until curl --fail-early -fsk ${remote}/api/v1/cfssl/health -o /dev/null; do
          echo "health check failed"
          sleep 2
        done
      '';

      serviceConfig = {
        WorkingDirectory = cfg.dataDir;
        StateDirectory = cfg.dataDir;
        StateDirectoryMode = 700;
        Restart = "always";
        User = "cfssl";

        ExecStart = with cfg; let
          opt = n: v: optionalString (v != null) ''-${n}="${v}"'';
        in lib.concatStringsSep " \\\n" [
          "${pkgs.cfssl}/bin/cfssl serve"
          (opt "address" address)
          (opt "port" (toString port))
          (opt "ca" ca)
          (opt "ca-key" caKey)
          (opt "ca-bundle" caBundle)
          (opt "int-bundle" intBundle)
          (opt "int-dir" intDir)
          (opt "metadata" metadata)
          (opt "remote" remote)
          (opt "config" configFile)
          (opt "responder" responder)
          (opt "responder-key" responderKey)
          (opt "tls-key" tlsKey)
          (opt "tls-cert" tlsCert)
          (opt "mutual-tls-ca" mutualTlsCa)
          (opt "mutual-tls-cn" mutualTlsCn)
          (opt "mutual-tls-client-key" mutualTlsClientKey)
          (opt "mutual-tls-client-cert" mutualTlsClientCert)
          (opt "tls-remote-ca" tlsRemoteCa)
          (opt "db-config" dbConfig)
          (opt "loglevel" (toString logLevel))
        ];
      };
    };

    services.cfssl = {
      configFile = mkIf (cfg.configuration != {}) (mkDefault cfg.configuration.file);
      ca = mkDefault "${cfg.dataDir}/ca.pem";
      caKey = mkDefault "${cfg.dataDir}/ca-key.pem";
      tlsCert = mkIf cfg.initssl.enable (mkDefault "${cfg.dataDir}/cfssl.pem");
      tlsKey = mkIf cfg.initssl.enable (mkDefault "${cfg.dataDir}/cfssl-key.pem");

      configuration.signing.default = mkDefault {
        expiry = "8760h";
        usages = ["signing" "key encipherment" "client auth" "server auth"];
      };
    };
  };
}
