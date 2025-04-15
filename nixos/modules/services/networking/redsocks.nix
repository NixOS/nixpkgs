{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.services.redsocks;
in
{
  ##### interface
  options = {
    services.redsocks = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable redsocks.";
      };

      log_debug = mkOption {
        type = types.bool;
        default = false;
        description = "Log connection progress.";
      };

      log_info = mkOption {
        type = types.bool;
        default = false;
        description = "Log start and end of client sessions.";
      };

      log = mkOption {
        type = types.str;
        default = "stderr";
        description = ''
          Where to send logs.

          Possible values are:
            - stderr
            - file:/path/to/file
            - syslog:FACILITY where FACILITY is any of "daemon", "local0",
              etc.
        '';
      };

      chroot = mkOption {
        type = with types; nullOr str;
        default = null;
        description = ''
          Chroot under which to run redsocks. Log file is opened before
          chroot, but if logging to syslog /etc/localtime may be required.
        '';
      };

      redsocks = mkOption {
        description = ''
          Local port to proxy associations to be performed.

          The example shows how to configure a proxy to handle port 80 as HTTP
          relay, and all other ports as HTTP connect.
        '';
        example = [
          {
            port = 23456;
            proxy = "1.2.3.4:8080";
            type = "http-relay";
            redirectCondition = "--dport 80";
            doNotRedirect = [ "-d 1.2.0.0/16" ];
          }
          {
            port = 23457;
            proxy = "1.2.3.4:8080";
            type = "http-connect";
            redirectCondition = true;
            doNotRedirect = [ "-d 1.2.0.0/16" ];
          }
        ];
        type = types.listOf (
          types.submodule {
            options = {
              ip = mkOption {
                type = types.str;
                default = "127.0.0.1";
                description = ''
                  IP on which redsocks should listen. Defaults to 127.0.0.1 for
                  security reasons.
                '';
              };

              port = mkOption {
                type = types.port;
                default = 12345;
                description = "Port on which redsocks should listen.";
              };

              proxy = mkOption {
                type = types.str;
                description = ''
                  Proxy through which redsocks should forward incoming traffic.
                  Example: "example.org:8080"
                '';
              };

              type = mkOption {
                type = types.enum [
                  "socks4"
                  "socks5"
                  "http-connect"
                  "http-relay"
                ];
                description = "Type of proxy.";
              };

              login = mkOption {
                type = with types; nullOr str;
                default = null;
                description = "Login to send to proxy.";
              };

              password = mkOption {
                type = with types; nullOr str;
                default = null;
                description = ''
                  Password to send to proxy. WARNING, this will end up
                  world-readable in the store! Awaiting
                  https://github.com/NixOS/nix/issues/8 to be able to fix.
                '';
              };

              disclose_src = mkOption {
                type = types.enum [
                  "false"
                  "X-Forwarded-For"
                  "Forwarded_ip"
                  "Forwarded_ipport"
                ];
                default = "false";
                description = ''
                  Way to disclose client IP to the proxy.
                    - "false": do not disclose

                  http-connect supports the following ways:
                    - "X-Forwarded-For": add header "X-Forwarded-For: IP"
                    - "Forwarded_ip": add header "Forwarded: for=IP" (see RFC7239)
                    - "Forwarded_ipport": add header 'Forwarded: for="IP:port"'
                '';
              };

              redirectInternetOnly = mkOption {
                type = types.bool;
                default = true;
                description = "Exclude all non-globally-routable IPs from redsocks";
              };

              doNotRedirect = mkOption {
                type = with types; listOf str;
                default = [ ];
                description = ''
                  Iptables filters that if matched will get the packet off of
                  redsocks.
                '';
                example = [ "-d 1.2.3.4" ];
              };

              redirectCondition = mkOption {
                type = with types; either bool str;
                default = false;
                description = ''
                  Conditions to make outbound packets go through this redsocks
                  instance.

                  If set to false, no packet will be forwarded. If set to true,
                  all packets will be forwarded (except packets excluded by
                  redirectInternetOnly).

                  If set to a string, this is an iptables filter that will be
                  matched against packets before getting them into redsocks. For
                  example, setting it to "--dport 80" will only send
                  packets to port 80 to redsocks. Note "-p tcp" is always
                  implicitly added, as udp can only be proxied through redudp or
                  the like.
                '';
              };
            };
          }
        );
      };

      # TODO: Add support for redudp and dnstc
    };
  };

  ##### implementation
  config =
    let
      redsocks_blocks = concatMapStrings (
        block:
        let
          proxy = splitString ":" block.proxy;
        in
        ''
          redsocks {
            local_ip = ${block.ip};
            local_port = ${toString block.port};

            ip = ${elemAt proxy 0};
            port = ${elemAt proxy 1};
            type = ${block.type};

            ${optionalString (block.login != null) "login = \"${block.login}\";"}
            ${optionalString (block.password != null) "password = \"${block.password}\";"}

            disclose_src = ${block.disclose_src};
          }
        ''
      ) cfg.redsocks;
      configfile = pkgs.writeText "redsocks.conf" ''
        base {
          log_debug = ${if cfg.log_debug then "on" else "off"};
          log_info = ${if cfg.log_info then "on" else "off"};
          log = ${cfg.log};

          daemon = off;
          redirector = iptables;

          user = redsocks;
          group = redsocks;
          ${optionalString (cfg.chroot != null) "chroot = ${cfg.chroot};"}
        }

        ${redsocks_blocks}
      '';
      internetOnly = [
        # TODO: add ipv6-equivalent
        "-d 0.0.0.0/8"
        "-d 10.0.0.0/8"
        "-d 127.0.0.0/8"
        "-d 169.254.0.0/16"
        "-d 172.16.0.0/12"
        "-d 192.168.0.0/16"
        "-d 224.168.0.0/4"
        "-d 240.168.0.0/4"
      ];
      redCond = block: optionalString (isString block.redirectCondition) block.redirectCondition;
      iptables = concatImapStrings (
        idx: block:
        let
          chain = "REDSOCKS${toString idx}";
          doNotRedirect = concatMapStringsSep "\n" (
            f: "ip46tables -t nat -A ${chain} ${f} -j RETURN 2>/dev/null || true"
          ) (block.doNotRedirect ++ (optionals block.redirectInternetOnly internetOnly));
        in
        optionalString (block.redirectCondition != false) ''
          ip46tables -t nat -F ${chain} 2>/dev/null || true
          ip46tables -t nat -N ${chain} 2>/dev/null || true
          ${doNotRedirect}
          ip46tables -t nat -A ${chain} -p tcp -j REDIRECT --to-ports ${toString block.port}

          # TODO: show errors, when it will be easily possible by a switch to
          # iptables-restore
          ip46tables -t nat -A OUTPUT -p tcp ${redCond block} -j ${chain} 2>/dev/null || true
        ''
      ) cfg.redsocks;
    in
    mkIf cfg.enable {
      users.groups.redsocks = { };
      users.users.redsocks = {
        description = "Redsocks daemon";
        group = "redsocks";
        isSystemUser = true;
      };

      systemd.services.redsocks = {
        description = "Redsocks";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        script = "${pkgs.redsocks}/bin/redsocks -c ${configfile}";
      };

      networking.firewall.extraCommands = iptables;

      networking.firewall.extraStopCommands = concatImapStringsSep "\n" (
        idx: block:
        let
          chain = "REDSOCKS${toString idx}";
        in
        optionalString (
          block.redirectCondition != false
        ) "ip46tables -t nat -D OUTPUT -p tcp ${redCond block} -j ${chain} 2>/dev/null || true"
      ) cfg.redsocks;
    };

  meta.maintainers = with lib.maintainers; [ ekleog ];
}
