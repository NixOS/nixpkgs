{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.cfssl;
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
      type = types.nullOr types.str;
      description = "Path to configuration file. Do not put this in nix-store as it might contain secrets.";
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

    systemd.services.cfssl = {
      description = "CFSSL CA API server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        WorkingDirectory = cfg.dataDir;
        StateDirectory = cfg.dataDir;
        StateDirectoryMode = 700;
        Restart = "always";
        User = "cfssl";

        ExecStart = with cfg; let
          opt = n: v: optionalString (v != null) ''-${n}="${v}"'';
        in
          lib.concatStringsSep " \\\n" [
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
      ca = mkDefault "${cfg.dataDir}/ca.pem";
      caKey = mkDefault "${cfg.dataDir}/ca-key.pem";
    };
  };
}
