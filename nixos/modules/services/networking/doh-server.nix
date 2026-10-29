{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.doh-server;
  toml = pkgs.formats.toml { };
in
{
  options.services.doh-server = {
    enable = lib.mkEnableOption "DNS-over-HTTPS server";

    package = lib.mkPackageOption pkgs "dns-over-https" { };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = toml.type;
        options = {

          listen = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [
              "127.0.0.1:8053"
              "[::1]:8053"
            ];
            example = [ ":443" ];
            description = "HTTP listen address and port";
          };

          path = lib.mkOption {
            type = lib.types.str;
            default = "/dns-query";
            example = "/dns-query";
            description = "HTTP path for resolve application";
          };

          upstream = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [
              "udp:1.1.1.1:53"
              "udp:1.0.0.1:53"
              "udp:8.8.8.8:53"
              "udp:8.8.4.4:53"
            ];
            example = [ "udp:127.0.0.1:53" ];
            description = ''
              Upstream DNS resolver.
              If multiple servers are specified, a random one will be chosen each time.
              You can use "udp", "tcp" or "tcp-tls" for the type prefix.
              For "udp", UDP will first be used, and switch to TCP when the server asks to or the response is too large.
              For "tcp", only TCP will be used.
              For "tcp-tls", DNS-over-TLS (RFC 7858) will be used to secure the upstream connection.
            '';
          };

          timeout = lib.mkOption {
            type = lib.types.int;
            default = 10;
            example = 15;
            description = "Upstream timeout";
          };

          tries = lib.mkOption {
            type = lib.types.int;
            default = 3;
            example = 5;
            description = "Number of tries if upstream DNS fails";
          };

          verbose = lib.mkOption {
            type = lib.types.bool;
            default = false;
            example = true;
            description = "Enable logging";
          };

          log_guessed_client_ip = lib.mkOption {
            type = lib.types.bool;
            default = false;
            example = true;
            description = ''
              Enable log IP from HTTPS-reverse proxy header: X-Forwarded-For or X-Real-IP
              Note: http uri/useragent log cannot be controlled by this config
            '';
          };

          ecs_allow_non_global_ip = lib.mkOption {
            type = lib.types.bool;
            default = false;
            example = true;
            description = ''
              By default, non global IP addresses are never forwarded to upstream servers.
              This is to prevent two things from happening:
                1. the upstream server knowing your private LAN addresses;
                2. the upstream server unable to provide geographically near results,
                  or even fail to provide any result.
              However, if you are deploying a split tunnel corporation network environment, or for any other reason you want to inhibit this behavior and allow local (eg RFC1918) address to be forwarded, change the following option to "true".
            '';
          };

          ecs_use_precise_ip = lib.mkOption {
            type = lib.types.bool;
            default = false;
            example = true;
            description = ''
              If ECS is added to the request, let the full IP address or cap it to 24 or 128 mask. This option is to be used only on private networks where knowledge of the terminal endpoint may be required for security purposes (eg. DNS Firewalling). Not a good option on the internet where IP address may be used to identify the user and not only the approximate location.
            '';
          };
        };
      };
      default = { };
      example = {
        listen = [ ":8153" ];
        upstream = [ "udp:127.0.0.1:53" ];
      };
      description = "Configuration of doh-server in toml. See example in <https://github.com/m13253/dns-over-https/blob/master/doh-server/doh-server.conf>";
    };

    useACMEHost = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "doh.example.com";
      description = ''
        A host of an existing Let's Encrypt certificate to use.
        *Note that this option does not create any certificates, nor it does add subdomains to existing ones – you will need to create them manually using [](#opt-security.acme.certs).*
      '';
    };

    configFile = lib.mkOption {
      type = lib.types.path;
      example = "/path/to/doh-server.conf";
      description = ''
        The config file for the doh-server.
        Setting this option will override any configuration applied by the `settings` option.
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    services.doh-server.configFile = lib.mkDefault (toml.generate "doh-server.conf" cfg.settings);
    services.doh-server.settings = lib.mkIf (cfg.useACMEHost != null) (
      let
        sslCertDir = config.security.acme.certs.${cfg.useACMEHost}.directory;
      in
      {
        cert = "${sslCertDir}/cert.pem";
        key = "${sslCertDir}/key.pem";
      }
    );
    systemd.services.doh-server = {
      description = "DNS-over-HTTPS Server";
      documentation = [ "https://github.com/m13253/dns-over-https" ];
      after = [
        "network.target"
      ]
      ++ lib.optional (cfg.useACMEHost != null) "acme-${cfg.useACMEHost}.service";
      wants = lib.optional (cfg.useACMEHost != null) "acme-${cfg.useACMEHost}.service";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        ExecStart = "${cfg.package}/bin/doh-server -conf ${cfg.configFile}";
        LimitNOFILE = 1048576;
        Restart = "always";
        RestartSec = 3;
        Type = "simple";
        DynamicUser = true;
        SupplementaryGroups = lib.optional (cfg.useACMEHost != null) "acme";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ DictXiong ];
  meta.doc = ./doh-server.md;
}
