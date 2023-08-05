{ lib
, config
, pkgs
, ...
}:

let
  cfg = config.services.acme-dns;
  format = pkgs.formats.toml { };
  inherit (lib)
    literalExpression
    mdDoc
    mkEnableOption
    mkOption
    mkPackageOptionMD
    types
    ;
  domain = "acme-dns.example.com";
in
{
  options.services.acme-dns = {
    enable = mkEnableOption (mdDoc "acme-dns");

    package = mkPackageOptionMD pkgs "acme-dns" { };

    settings = mkOption {
      description = mdDoc ''
        Free-form settings written directly to the `acme-dns.cfg` file.
        Refer to <https://github.com/joohoi/acme-dns/blob/master/README.md#configuration> for supported values.
      '';

      default = { };

      type = types.submodule {
        freeformType = format.type;
        options = {
          general = {
            listen = mkOption {
              type = types.str;
              description = mdDoc "IP+port combination to bind and serve the DNS server on.";
              default = "[::]:53";
              example = "127.0.0.1:53";
            };

            protocol = mkOption {
              type = types.enum [ "both" "both4" "both6" "udp" "udp4" "udp6" "tcp" "tcp4" "tcp6" ];
              description = mdDoc "Protocols to serve DNS responses on.";
              default = "both";
            };

            domain = mkOption {
              type = types.str;
              description = mdDoc "Domain name to serve the requests off of.";
              example = domain;
            };

            nsname = mkOption {
              type = types.str;
              description = mdDoc "Zone name server.";
              example = domain;
            };

            nsadmin = mkOption {
              type = types.str;
              description = mdDoc "Zone admin email address for `SOA`.";
              example = "admin.example.com";
            };

            records = mkOption {
              type = types.listOf types.str;
              description = mdDoc "Predefined DNS records served in addition to the `_acme-challenge` TXT records.";
              example = literalExpression ''
                [
                  # replace with your acme-dns server's public IPv4
                  "${domain}. A 198.51.100.1"
                  # replace with your acme-dns server's public IPv6
                  "${domain}. AAAA 2001:db8::1"
                  # ${domain} should resolve any *.${domain} records
                  "${domain}. NS ${domain}."
                ]
              '';
            };
          };

          database = {
            engine = mkOption {
              type = types.enum [ "sqlite3" "postgres" ];
              description = mdDoc "Database engine to use.";
              default = "sqlite3";
            };
            connection = mkOption {
              type = types.str;
              description = mdDoc "Database connection string.";
              example = "postgres://user:password@localhost/acmedns";
              default = "/var/lib/acme-dns/acme-dns.db";
            };
          };

          api = {
            ip = mkOption {
              type = types.str;
              description = mdDoc "IP to bind the HTTP API on.";
              default = "[::]";
              example = "127.0.0.1";
            };

            port = mkOption {
              type = types.port;
              description = mdDoc "Listen port for the HTTP API.";
              default = 8080;
              # acme-dns expects this value to be a string
              apply = toString;
            };

            disable_registration = mkOption {
              type = types.bool;
              description = mdDoc "Whether to disable the HTTP registration endpoint.";
              default = false;
              example = true;
            };

            tls = mkOption {
              type = types.enum [ "letsencrypt" "letsencryptstaging" "cert" "none" ];
              description = mdDoc "TLS backend to use.";
              default = "none";
            };
          };


          logconfig = {
            loglevel = mkOption {
              type = types.enum [ "error" "warning" "info" "debug" ];
              description = mdDoc "Level to log on.";
              default = "info";
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.packages = [ cfg.package ];
    systemd.services.acme-dns = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = [ "" "${lib.getExe cfg.package} -c ${format.generate "acme-dns.toml" cfg.settings}" ];
        StateDirectory = "acme-dns";
        WorkingDirectory = "%S/acme-dns";
        DynamicUser = true;
      };
    };
  };
}
