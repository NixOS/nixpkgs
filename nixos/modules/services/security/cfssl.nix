{
  config,
  options,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.cfssl;
in
{
  options.services.cfssl = {
    enable = lib.mkEnableOption "the CFSSL CA api-server";

    dataDir = lib.mkOption {
      default = "/var/lib/cfssl";
      type = lib.types.path;
      description = ''
        The work directory for CFSSL.

        ::: {.note}
        If left as the default value this directory will automatically be
        created before the CFSSL server starts, otherwise you are
        responsible for ensuring the directory exists with appropriate
        ownership and permissions.
        :::
      '';
    };

    address = lib.mkOption {
      default = "127.0.0.1";
      type = lib.types.str;
      description = "Address to bind.";
    };

    port = lib.mkOption {
      default = 8888;
      type = lib.types.port;
      description = "Port to bind.";
    };

    ca = lib.mkOption {
      defaultText = lib.literalExpression ''"''${cfg.dataDir}/ca.pem"'';
      type = lib.types.str;
      description = "CA used to sign the new certificate -- accepts '[file:]fname' or 'env:varname'.";
    };

    caKey = lib.mkOption {
      defaultText = lib.literalExpression ''"file:''${cfg.dataDir}/ca-key.pem"'';
      type = lib.types.str;
      description = "CA private key -- accepts '[file:]fname' or 'env:varname'.";
    };

    caBundle = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      description = "Path to root certificate store.";
    };

    intBundle = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      description = "Path to intermediate certificate store.";
    };

    intDir = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      description = "Intermediates directory.";
    };

    metadata = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      description = ''
        Metadata file for root certificate presence.
        The content of the file is a json dictionary (k,v): each key k is
        a SHA-1 digest of a root certificate while value v is a list of key
        store filenames.
      '';
    };

    remote = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.str;
      description = "Remote CFSSL server.";
    };

    configFile = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.str;
      description = "Path to configuration file. Do not put this in nix-store as it might contain secrets.";
    };

    responder = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      description = "Certificate for OCSP responder.";
    };

    responderKey = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.str;
      description = "Private key for OCSP responder certificate. Do not put this in nix-store.";
    };

    tlsKey = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.str;
      description = "Other endpoint's CA private key. Do not put this in nix-store.";
    };

    tlsCert = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      description = "Other endpoint's CA to set up TLS protocol.";
    };

    mutualTlsCa = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      description = "Mutual TLS - require clients be signed by this CA.";
    };

    mutualTlsCn = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.str;
      description = "Mutual TLS - regex for whitelist of allowed client CNs.";
    };

    tlsRemoteCa = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      description = "CAs to trust for remote TLS requests.";
    };

    mutualTlsClientCert = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      description = "Mutual TLS - client certificate to call remote instance requiring client certs.";
    };

    mutualTlsClientKey = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      description = "Mutual TLS - client key to call remote instance requiring client certs. Do not put this in nix-store.";
    };

    dbConfig = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      description = "Certificate db configuration file. Path must be writeable.";
    };

    logLevel = lib.mkOption {
      default = 1;
      type = lib.types.ints.between 0 5;
      description = "Log level (0 = DEBUG, 5 = FATAL).";
    };

    disable = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.commas;
      description = "Endpoints to disable (comma-separated list)";
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.cfssl = {
      gid = config.ids.gids.cfssl;
    };

    users.users.cfssl = {
      description = "cfssl user";
      home = cfg.dataDir;
      group = "cfssl";
      uid = config.ids.uids.cfssl;
    };

    systemd.services.cfssl = {
      description = "CFSSL CA API server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = lib.mkMerge [
        {
          WorkingDirectory = cfg.dataDir;
          Restart = "always";
          User = "cfssl";
          Group = "cfssl";

          ExecStart =
            with cfg;
            let
              opt = n: v: lib.optionalString (v != null) ''-${n}="${v}"'';
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
              (opt "disable" disable)
            ];
        }
        (lib.mkIf (cfg.dataDir == options.services.cfssl.dataDir.default) {
          StateDirectory = baseNameOf cfg.dataDir;
          StateDirectoryMode = 700;
        })
      ];
    };

    services.cfssl = {
      ca = lib.mkDefault "${cfg.dataDir}/ca.pem";
      caKey = lib.mkDefault "${cfg.dataDir}/ca-key.pem";
    };
  };
}
