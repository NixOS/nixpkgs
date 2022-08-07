{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.dnscache;

  dnscache-root = pkgs.runCommand "dnscache-root" { preferLocalBuild = true; } ''
    mkdir -p $out/{servers,ip}

    ${concatMapStrings (ip: ''
      touch "$out/ip/"${lib.escapeShellArg ip}
    '') cfg.clientIps}

    ${concatStrings (mapAttrsToList (host: ips: ''
      ${concatMapStrings (ip: ''
        echo ${lib.escapeShellArg ip} >> "$out/servers/"${lib.escapeShellArg host}
      '') ips}
    '') cfg.domainServers)}

    # if a list of root servers was not provided in config, copy it
    # over. (this is also done by dnscache-conf, but we 'rm -rf
    # /var/lib/dnscache/root' below & replace it wholesale with this,
    # so we have to ensure servers/@ exists ourselves.)
    if [ ! -e $out/servers/@ ]; then
      # symlink does not work here, due chroot
      cp ${pkgs.djbdns}/etc/dnsroots.global $out/servers/@;
    fi
  '';

in {

  ###### interface

  options = {
    services.dnscache = {

      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc "Whether to run the dnscache caching dns server.";
      };

      ip = mkOption {
        default = "0.0.0.0";
        type = types.str;
        description = lib.mdDoc "IP address on which to listen for connections.";
      };

      clientIps = mkOption {
        default = [ "127.0.0.1" ];
        type = types.listOf types.str;
        description = lib.mdDoc "Client IP addresses (or prefixes) from which to accept connections.";
        example = ["192.168" "172.23.75.82"];
      };

      domainServers = mkOption {
        default = { };
        type = types.attrsOf (types.listOf types.str);
        description = lib.mdDoc ''
          Table of {hostname: server} pairs to use as authoritative servers for hosts (and subhosts).
          If entry for @ is not specified predefined list of root servers is used.
        '';
        example = literalExpression ''
          {
            "@" = ["8.8.8.8" "8.8.4.4"];
            "example.com" = ["192.168.100.100"];
          }
        '';
      };

      forwardOnly = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Whether to treat root servers (for @) as caching
          servers, requesting addresses the same way a client does. This is
          needed if you want to use e.g. Google DNS as your upstream DNS.
        '';
      };

    };
  };

  ###### implementation

  config = mkIf config.services.dnscache.enable {
    environment.systemPackages = [ pkgs.djbdns ];
    users.users.dnscache.isSystemUser = true;

    systemd.services.dnscache = {
      description = "djbdns dnscache server";
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [ bash daemontools djbdns ];
      preStart = ''
        rm -rf /var/lib/dnscache
        dnscache-conf dnscache dnscache /var/lib/dnscache ${config.services.dnscache.ip}
        rm -rf /var/lib/dnscache/root
        ln -sf ${dnscache-root} /var/lib/dnscache/root
      '';
      script = ''
        cd /var/lib/dnscache/
        ${optionalString cfg.forwardOnly "export FORWARDONLY=1"}
        exec ./run
      '';
    };
  };
}
