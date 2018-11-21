{ config, lib, pkgs, ... }:

let
  inherit (lib) any concatStrings getBin id literalExample mapAttrs'
    mapAttrsToList mkDefault mkEnableOption mkIf mkMerge mkOption nameValuePair
    optionalString types;
  inherit (builtins) elemAt head isFunction isList isString length tail;

  dnsLib = rec {
    parseRecord = f: l: if isFunction f
                        then if (length l) > 0
                             then parseRecord (f (head l)) (tail l)
                             else parseRecord (f "") []
                        else f;

    dataFlagsSet = record: ttl: ts: location: record // { inherit ttl ts location; };

    Flag = parseRecord dataFlagsSet;
    AFSDB = parseRecord (cell: server: dataFlagsSet
      { inherit cell server; });
    SRV = parseRecord (service: priority: weight: port: target: dataFlagsSet
      { inherit service priority weight port target; });
    TXT = parseRecord (service: txt: dataFlagsSet { inherit service txt; });
    URI = parseRecord (service: priority: weight: payload: dataFlagsSet { inherit service priority weight payload; });
  };

  convRec = r: if isList r
               then let type = elemAt r 0;
                    in { inherit type; } // (dnsLib.${type} (tail r))
               else (if isString r
                     then { type = "DATA"; data = r; }
                     else r);
  libTinydns = import ./tinydns/lib.nix { inherit lib; };
in {
  ###### interface

  options = {
    services.tinydns = mkOption {
      description = "An attribute set of tinydns service configurations. Each Attribute must name the IP address this server will listen on.";
      example = literalExample ''
        services.tinydns = {
          "128.1.2.3" = {
            enable = true;
            data = "=host.on.network.a:128.1.2.3";
          };
          "10.0.0.1" = {
            enable = true;
            data = "=host.on.network.b:10.0.0.1";
          };
        }
      '';
      default = {};
      type = types.attrsOf (types.submodule (
      { config, name, ... }:
      {
        options = {
          enable = mkOption {
            default = false;
            type = types.bool;
            description = ''
              Whether to run the tinydns DNS server on the IP address given as
              the submodule's name. To answer queries larger than 512 bytes,
              make sure to also enable <literal>listenTCP</literal>.
            '';
          };

          data = mkOption {
            default = [];
            type = with types; listOf unspecified;
            apply = map convRec;
            description = ''
              DNS records, one per line, in the format described in
              <citerefentry><refentrytitle>tinydns-data</refentrytitle><manvolnum>8</manvolnum></citerefentry>.
              Many advanced records need special encoding when appearing inside this
              file. Use the functions from <literal>lib.tinydns</literal> to
              generate various kinds of records. All record-building functions
              accept a variable amount of arguments with unspecified arguments
              filled up with the empty string. See also the example below.

              The following record-building functions are implemented in
              <literal>lib.tinydns</literal>:

              <literal>Flag</literal> has one mandatory argument; a DNS
              record in the format described in
              <citerefentry><refentrytitle>tinydns-data</refentrytitle><manvolnum>8</manvolnum></citerefentry>;
              adds up to three additional flags to the DNS record, TTL, timestamp
              from which this record becomes valid and the location it is valid in.
              All other record-building functions also respect these flags as their
              last three arguments in addition to the arguments that are relevant
              for their particular type. TTL must be an integer. If timestamp is
              given as an integer, it is taken as a UNIX timestamp, otherwise it
              must be a string and is taken to be a hex-encoded TAI64 timestamp.
              Location must be a string.

              <literal>AFSDB</literal> has two mandatory arguments;
              the requested AFS cell and the database server.

              <literal>SRV</literal> has five mandatory arguments; the
              requested service, a priority (int), a weight (int), a port (int), and
              a target.

              <literal>TXT</literal> has two mandatory arguments; the
              requested service and a data field in the format that the service
              requires.

              <literal>URI</literal> has four mandatory arguments; the
              requested service, a priority (int), a weight (int), and a target.
            '';
            # example = literalExample ''
            #   ['''
            #   %ex
            #   %in:10.0.0
            #   .example.com:127.0.0.2:b
            #   =server.example.com:1.2.3.4:::ex
            #   =server.example.com:10.0.0.1:3600:400000005c0f6e84:in
            #   +future.example.com:127.0.0.127
            #   '''
            #   ''${TXT [ "_kerberos.example.com" "EXAMPLE.COM" 360 ]}
            #   ''${SRV [ "_kerberos._udp.example.com" 10 100 88 "current.example.com." ]}
            #   ''${URIs [ [ "_kerberos.EXAMPLE.COM" 10 1 "krb5srv:m:udp:current.example.com" "" 1542812577 ]
            #           [ "_kerberos.EXAMPLE.COM" 10 1 "krb5srv:m:udp:future.example.com"  "" "410000005c6bd4d3" ] ]}
            #   ]
            # '';
          };

          listenTCP = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Also answer queries via TCP. You need this to answer queries whose
              responses are larger than 512 bytes and for zone transfers via AXFR
              (not supported, use <literal>secondaries</literal> instead).
            '';
          };

          rootPath = mkOption {
            internal = true;
            type = types.str;
            default = "/run/tinydns-${name}";
            description = ''
              Set this to an on-disk location to permanently store the DNS record database.
            '';
          };

          secondaries = mkOption {
            type = types.attrsOf (types.submodule (
            { config, name, ... }:
            {
              options = {
                uri = mkOption {
                  type = types.str;
                  example = "tinydns@secondary.example.com";
                  description = ''
                    SSH connection uri to the secondary server. On zone updates the
                    new set of DNS records is transferred to this secondary server
                    via SSH. Make sure to add the secondary's SSH host key to
                    programs.ssh.knownHosts!
                  '';
                };
                sshKey = mkOption {
                  type = types.str;
                  example = "/some/secure/location";
                  description = ''
                    File location of the private SSH key to authenticate zone
                    updates to the secondary server.
                  '';
                };
              };
              config = {};
            }));
            default = {};
            description = ''
              Set of secondary DNS servers. Updates to this server's DNS records are
              sent to secondaries via SSH.
            '';
          };

          secondary.enable = mkEnableOption "Configure this tinydns instance as a secondary server receiving its data via SSH.";

          secondary.sshKey = mkOption {
            type = types.str;
            description = "SSH key to authenticate zone transfers to the secondary DNS server.";
            default = "";
          };
        };
      }));
    };
  };

  ###### implementation

  config = mkMerge [
    (mkIf ((any id (mapAttrsToList (_: v: v.enable) config.services.tinydns))
           && (any id (mapAttrsToList (_: v: v.secondaries != {}) config.services.tinydns))) {
      # Restrict to a single session at a time
      services.openssh.extraConfig = ''
        Match User tinydns
        MaxSessions=1
        Match All
      '';
    })

    (mkIf (any id (mapAttrsToList (_: v: v.enable) config.services.tinydns)) {

      environment.systemPackages = [ pkgs.djbdns ];

      users.users.tinydns = {
        isSystemUser = true;
        uid = config.ids.uids.tinydns;
        group = "tinydns";
        shell = "/run/current-system/sw/bin/bash";
        openssh.authorizedKeys.keys = mapAttrsToList (name: cfg: let
          # Expects tinydns data on standard input
          tinydnsReceive = pkgs.writeScript "tinydns-receive" ''
        #!${pkgs.stdenv.shell} -e
        cd ${lib.escapeShellArg cfg.rootPath}
        (
          flock -n 5 || exit 1
          mv data data.backup
          cat >data
          if ${getBin pkgs.djbdns}/bin/tinydns-data ; then
            rm data.backup
          else
            mv data.backup data
          fi
          # Do not allow zone transfers to run more often than once per second due to
          # minimum DNS record time resolution.
          sleep 1
        ) 5>data-lock
        '';
        in optionalString (cfg.secondary.sshKey != "") ''
        restrict,command="${tinydnsReceive}" ${cfg.secondary.sshKey}
      '') config.services.tinydns;
      };
      users.groups.tinydns = {
        gid = config.ids.gids.tinydns;
      };

      systemd.services = (mapAttrs' (ip: cfg: nameValuePair "tinydns-${ip}" {
        enable = cfg.enable;
        description = "djbdns tinydns server";
        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        requires = [ "network-online.target" ];
        environment = {
          IP = ip;
          ROOT = cfg.rootPath;
          UID = "${toString config.users.users.tinydns.uid}";
          GID = "${toString config.users.groups.tinydns.gid}";
          AXFR_JOBS = "2"; # Number of concurrent zone transfers to secondary servers.
        };
        path = with pkgs; [ coreutils djbdns ];
        serviceConfig = {
          # Drops privileges and chroots to ROOT by itself
          ExecStart = "${getBin pkgs.djbdns}/bin/tinydns";
          LimitDATA = mkDefault "40000000";
          RestartSec = 1;
          Restart = "always";
        };
        preStart = ''
        rm -rf "$ROOT"
        mkdir -m750 -p "$ROOT"
        chown ''${UID}:''${GID} "$ROOT"
        cd "$ROOT"
        ${if cfg.secondary.enable then "touch data" else "ln -sf ${pkgs.writeText "tinydns-data" (libTinydns.toTxt cfg.data)} data"}
        tinydns-data
      '';
        reload = let
          tinydnsSend = pkgs.writeText "tinydns-send.mk"
            (concatStrings
              (mapAttrsToList (k: v: "-a -x -S none -T -i ${v.sshKey} ${v.uri}")
                cfg.secondaries));
        in ''
        cd "$ROOT"
        ${optionalString (!cfg.secondary.enable) "ln -sf ${pkgs.writeText "tinydns-data" (libTinydns.toTxt cfg.data)} data"}
        tinydns-data
        ${optionalString (cfg.secondaries != {})
          "${getBin pkgs.findutils}/bin/xargs -L $AXFR_JOBS -P $AXFR_JOBS -a ${tinydnsSend} ${getBin pkgs.openssh}/bin/ssh <data"}
      '';
        reloadIfChanged = true;
      }) config.services.tinydns) // (mapAttrs' (ip: cfg: nameValuePair "axfrdns-${ip}@" {
        enable = cfg.enable;
        description = "axfrdns tcp dns server";
        after = [ "tinydns-${ip}.service" ];
        requires = [ "tinydns-${ip}.service" ];
        environment = {
          IP = ip;
          ROOT = cfg.rootPath;
          AXFR = ""; # Do not allow any zone transfers!
          UID = "${toString config.users.users.tinydns.uid}";
          GID = "${toString config.users.groups.tinydns.gid}";
        };
        serviceConfig = {
          StandardInput = "socket";
          StandardError = "journal";
          ExecStart = "${getBin pkgs.djbdns}/bin/axfrdns";
          LimitDATA = mkDefault "15000000";
        };
      }) config.services.tinydns);

      systemd.sockets = mapAttrs' (ip: cfg: nameValuePair "axfrdns-${ip}" {
        enable = cfg.enable;
        wantedBy = [ "sockets.target" ];
        description = "axfrdns socket";
        listenStreams = [ "${ip}:53" ];
        socketConfig.Accept = true;
      }) config.services.tinydns;
    })
  ];
}
