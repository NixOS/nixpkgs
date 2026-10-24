{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.dnscache;

  dnscache-root = pkgs.runCommand "dnscache-root" { preferLocalBuild = true; } ''
    mkdir -p $out/{servers,ip}

    ${lib.concatMapStrings (ip: ''
      touch "$out/ip/"${lib.escapeShellArg ip}
    '') cfg.clientIps}

    ${lib.concatStrings (
      lib.mapAttrsToList (host: ips: ''
        ${lib.concatMapStrings (ip: ''
          echo ${lib.escapeShellArg ip} >> "$out/servers/"${lib.escapeShellArg host}
        '') ips}
      '') cfg.domainServers
    )}

    # dnscache chroots into this directory, so servers/@ (the list of root
    # servers) must exist. If the config did not provide one, fall back to
    # the packaged list.
    if [ ! -e $out/servers/@ ]; then
      # symlink does not work here, due chroot
      cp ${cfg.package}/etc/dnsroots.global $out/servers/@;
    fi

    ${cfg.postBuild}
  '';

in
{

  ###### interface

  options = {
    services.dnscache = {

      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to run the dnscache caching dns server.";
      };

      package = lib.mkPackageOption pkgs "djbdns" { };

      ip = lib.mkOption {
        default = "0.0.0.0";
        type = lib.types.str;
        description = "IP address on which to listen for connections.";
      };

      clientIps = lib.mkOption {
        default = [ "127.0.0.1" ];
        type = lib.types.listOf lib.types.str;
        description = "Client IP addresses (or prefixes) from which to accept connections.";
        example = [
          "192.168"
          "172.23.75.82"
        ];
      };

      domainServers = lib.mkOption {
        default = { };
        type = lib.types.attrsOf (lib.types.listOf lib.types.str);
        description = ''
          Table of {hostname: server} pairs to use as authoritative servers for hosts (and subhosts).
          If entry for @ is not specified predefined list of root servers is used.
        '';
        example = lib.literalExpression ''
          {
            "@" = ["8.8.8.8" "8.8.4.4"];
            "example.com" = ["192.168.100.100"];
          }
        '';
      };

      forwardOnly = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to treat root servers (for @) as caching
          servers, requesting addresses the same way a client does. This is
          needed if you want to use e.g. Google DNS as your upstream DNS.
        '';
      };

      postBuild = lib.mkOption {
        default = "";
        type = lib.types.lines;
        description = ''
          Shell commands run after the dnscache root directory has been
          assembled. They execute during the build of the root with the
          directory available as `$out`, allowing extra files to be
          created.
        '';
        example = lib.literalExpression ''
          '''
            echo 1.2.3.4 > "$out/servers/example.org"
          '''
        '';
      };

    };
  };

  ###### implementation

  config = lib.mkIf config.services.dnscache.enable {
    environment.systemPackages = [ cfg.package ];
    users.users.dnscache = {
      isSystemUser = true;
      group = "dnscache";
    };
    users.groups.dnscache = { };

    systemd.services.dnscache = {
      description = "djbdns dnscache server";
      wantedBy = [ "multi-user.target" ];

      # dnscache needs no writable state: it binds :53, chroots into the
      # read-only root from the store, drops privileges, and keeps its cache
      # in memory. It does its own setgroups/setgid/setuid, so it must start
      # as root; envuidgid passes it the dnscache uid/gid via $UID/$GID and it
      # drops itself, ending unprivileged. The 128-byte RNG seed is read from
      # stdin, which we feed from /dev/urandom.
      environment = {
        IP = cfg.ip;
        IPSEND = "0.0.0.0";
        CACHESIZE = "1000000";
        ROOT = dnscache-root;
        FORWARDONLY = lib.mkIf cfg.forwardOnly "1";
      };
      serviceConfig = {
        StandardInput = "file:/dev/urandom";
        # djbdns softlimit: -d DATALIMIT and -o250 open files.
        LimitDATA = 3000000;
        LimitNOFILE = 250;
        ExecStart = "${lib.getExe' pkgs.daemontools "envuidgid"} dnscache ${lib.getExe' cfg.package "dnscache"}";
      };
    };
  };
}
