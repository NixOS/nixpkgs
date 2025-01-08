{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.services.acme-dns;
  format = pkgs.formats.toml { };
  inherit (lib)
    literalExpression
    mkEnableOption
    lib.mkOption
    mkPackageOption
    types
    ;
  domain = "acme-dns.example.com";
in
{
  options.services.acme-dns = {
    enable = lib.mkEnableOption "acme-dns";

    package = lib.mkPackageOption pkgs "acme-dns" { };

    settings = lib.mkOption {
      description = ''
        Free-form settings written directly to the `acme-dns.cfg` file.
        Refer to <https://github.com/joohoi/acme-dns/blob/master/README.md#configuration> for supported values.
      '';

      default = { };

      type = lib.types.submodule {
        freeformType = format.type;
        options = {
          general = {
            listen = lib.mkOption {
              type = lib.types.str;
              description = "IP+port combination to bind and serve the DNS server on.";
              default = "[::]:53";
              example = "127.0.0.1:53";
            };

            protocol = lib.mkOption {
              type = lib.types.enum [
                "both"
                "both4"
                "both6"
                "udp"
                "udp4"
                "udp6"
                "tcp"
                "tcp4"
                "tcp6"
              ];
              description = "Protocols to serve DNS responses on.";
              default = "both";
            };

            domain = lib.mkOption {
              type = lib.types.str;
              description = "Domain name to serve the requests off of.";
              example = domain;
            };

            nsname = lib.mkOption {
              type = lib.types.str;
              description = "Zone name server.";
              example = domain;
            };

            nsadmin = lib.mkOption {
              type = lib.types.str;
              description = "Zone admin email address for `SOA`.";
              example = "admin.example.com";
            };

            records = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              description = "Predefined DNS records served in addition to the `_acme-challenge` TXT records.";
              example = lib.literalExpression ''
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
            engine = lib.mkOption {
              type = lib.types.enum [
                "sqlite3"
                "postgres"
              ];
              description = "Database engine to use.";
              default = "sqlite3";
            };
            connection = lib.mkOption {
              type = lib.types.str;
              description = "Database connection string.";
              example = "postgres://user:password@localhost/acmedns";
              default = "/var/lib/acme-dns/acme-dns.db";
            };
          };

          api = {
            ip = lib.mkOption {
              type = lib.types.str;
              description = "IP to bind the HTTP API on.";
              default = "[::]";
              example = "127.0.0.1";
            };

            port = lib.mkOption {
              type = lib.types.port;
              description = "Listen port for the HTTP API.";
              default = 8080;
              # acme-dns expects this value to be a string
              apply = toString;
            };

            disable_registration = lib.mkOption {
              type = lib.types.bool;
              description = "Whether to disable the HTTP registration endpoint.";
              default = false;
              example = true;
            };

            tls = lib.mkOption {
              type = lib.types.enum [
                "letsencrypt"
                "letsencryptstaging"
                "cert"
                "none"
              ];
              description = "TLS backend to use.";
              default = "none";
            };
          };

          logconfig = {
            loglevel = lib.mkOption {
              type = lib.types.enum [
                "error"
                "warning"
                "info"
                "debug"
              ];
              description = "Level to log on.";
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
        ExecStart = [
          ""
          "${lib.getExe cfg.package} -c ${format.generate "acme-dns.toml" cfg.settings}"
        ];
        StateDirectory = "acme-dns";
        WorkingDirectory = "%S/acme-dns";
        DynamicUser = true;
      };
    };
  };
}
