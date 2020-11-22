{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.dns-over-https;
  clientBootstrap = concatMapStringsSep "," (x: "\"${x}\"") cfg.client.bootstrap;
  clientListen = concatMapStringsSep "," (x: "\"${x}\"") cfg.client.listen;
  clientPassthrough = concatMapStringsSep "," (x: "\"${x}\"") cfg.client.passthrough;
  clientUpstream = concatMapStrings (s: "[[upstream.upstream_ietf]]\n  url = \"${s.url}\"\n  weight = ${toString s.weight}\n") cfg.client.upstream;
  serverListen = concatMapStringsSep "," (x: "\"${x}\"") cfg.server.listen;
  serverUpstream = concatMapStringsSep "," (x: "\"${x}\"") cfg.server.upstream;

  # See upstream: https://github.com/m13253/dns-over-https/blob/master/doh-client/doh-client.conf
  clientConf = pkgs.writeText "doh-client.conf" ''
    listen = [${clientListen}]

    [upstream]
    upstream_selector = "${cfg.client.upstreamSelector}"

    ${clientUpstream}

    [others]
    bootstrap = [${clientBootstrap}]
    passthrough = [${clientPassthrough}]
    timeout = 30
    no_cookies = true
    no_ecs = false
    no_ipv6 = false
    no_user_agent = false
    verbose = ${boolToString cfg.verbose}
  '';
  # See upstream: https://github.com/m13253/dns-over-https/blob/master/doh-server/doh-server.conf
  serverConf = pkgs.writeText "doh-server.conf" ''
    listen = [${serverListen}]
    local_addr = ""
    cert = ""
    key = ""
    path = "/dns-query"
    upstream = [${serverUpstream}]
    timeout = 10
    tries = 3
    verbose = ${boolToString cfg.verbose}
    log_guessed_client_ip = false
  '';

in
{
  options = {
    services.dns-over-https = {
      verbose = mkOption {
        type = types.bool;
        default = false;
        description = "Enable logging";
      };
      client = mkOption {
        description = "DNS-over-HTTPS Client";
        type = types.submodule {
          options = {
            enable = mkEnableOption "DNS-over-HTTPS Client";
            bootstrap = mkOption {
              description = "Bootstrap DNS server to resolve the address of the upstream resolver";
              type = types.listOf types.str;
              default = [ "8.8.8.8:53" "8.8.4.4:53" ];
              example = [
                # Google's resolver
                "8.8.8.8:53"
                "8.8.4.4:53"
                # CloudFlare's resolver
                "1.1.1.1:53"
                "1.0.0.1:53"
              ];
            };
            listen = mkOption {
              description = "DNS listen port";
              type = types.listOf types.str;
              default = [
                "127.0.0.1:53"
                "127.0.0.1:5380"
                "[::1]:53"
                "[::1]:5380"
              ];
              example = [ ":53" ];
            };
            upstreamSelector = mkOption {
              type = types.enum [ "random" "weighted_round_robin" "lvs_weighted_round_robin" ];
              description = "upstream selection algorithm";
              default = "random";
            };
            upstream = mkOption {
              description = "list of upstream servers to query";
              type = with types; listOf(submodule {
                options = {
                  url = mkOption {
                    type = str;
                    description = "URL for the backend, usually 'https://.../dns-query'";
                  };
                  weight = mkOption {
                    type = ints.u8;
                    description =
                      "weight should be in (0, 100], if upstream_selector is random, weight will be ignored";
                    default = 50;
                  };
                };
              });
              default = [ { url = "https://cloudflare-dns.com/dns-query"; } ];
              example = [
                # Google's resolver, good ECS, good DNSSEC
                { url = "https://dns.google/dns-query"; }
                # CloudFlare's resolver, bad ECS, good DNSSEC
                { url = "https://cloudflare-dns.com/dns-query"; }
                # CloudFlare's resolver, bad ECS, good DNSSEC
                { url = "https://1.1.1.1/dns-query"; }
                # DNS.SB's resolver, good ECS, good DNSSEC
                { url = "https://doh.dns.sb/dns-query"; }
                # Quad9's resolver, bad ECS, good DNSSEC
                { url = "https://9.9.9.9/dns-query"; }
                # CloudFlare's resolver via Tor
                { url = "https://dns4torpnlfs2ifuz2s2yf3fc7rdmsbhm6rw75euj35pac6ap25zgqad.onion/dns-query"; }
              ];
            };
            passthrough = mkOption {
              description =
                "Domain names to directly pass to bootstrap servers, allowing captive portal detection to work";
              type = types.listOf types.str;
              default = [
                "captive.apple.com"
                "connectivitycheck.gstatic.com"
                "detectportal.firefox.com"
                "msftconnecttest.com"
                "nmcheck.gnome.org"
                "pool.ntp.org"
                "time.apple.com"
                "time.asia.apple.com"
                "time.euro.apple.com"
                "time.nist.gov"
                "time.windows.com"
              ];
            };
          };
        };
        default = {};
      };
      server = mkOption {
        description = "DNS-over-HTTPS Server";
        type = types.submodule {
          options = {
            enable = mkEnableOption "DNS-over-HTTPS Server";
            listen = mkOption {
              description = "HTTP listen port";
              type = types.listOf types.str;
              default = [ "127.0.0.1:8053" "[::1]:8053" ];
              example = [ ":8053" ];
            };
            upstream = mkOption {
              description = "Upstream DNS resolver";
              type = types.listOf types.str;
              default = [
                "udp:1.1.1.1:53"
                "udp:1.0.0.1:53"
                "udp:8.8.8.8:53"
                "udp:8.8.4.4:53"
              ];
              example = [ "udp:127.0.0.1:53" ];
            };
          };
        };
        default = {};
      };
    };
  };

  config = {
    systemd.services.doh-client = mkIf cfg.client.enable {
      description = "DNS-over-HTTPS Client";
      after = [ "network.target" ];
      before = [ "nss-lookup.target" ];
      wants = [ "nss-lookup.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        ExecStart = "${pkgs.dns-over-https}/bin/doh-client -conf ${clientConf}";
        DynamicUser = true;
      };
    };
    systemd.services.doh-server = mkIf cfg.server.enable {
      description = "DNS-over-HTTPS Server";
      after = [ "network.target" ];
      before = [ "nss-lookup.target" ];
      wants = [ "nss-lookup.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        ExecStart = "${pkgs.dns-over-https}/bin/doh-server -conf ${serverConf}";
        DynamicUser = true;
      };
    };
  };
}
