{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.kresd;
  package = pkgs.knot-resolver;

  configFile = pkgs.writeText "kresd.conf" cfg.extraConfig;
in

{
  meta.maintainers = [ maintainers.vcunat /* upstream developer */ ];

  ###### interface
  options.services.kresd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable knot-resolver domain name server.
        DNSSEC validation is turned on by default.
        You can run <literal>sudo nc -U /run/kresd/control</literal>
        and give commands interactively to kresd.
      '';
    };
    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Extra lines to be added verbatim to the generated configuration file.
      '';
    };
    cacheDir = mkOption {
      type = types.path;
      default = "/var/cache/kresd";
      description = ''
        Directory for caches.  They are intended to survive reboots.
      '';
    };
    interfaces = mkOption {
      type = with types; listOf str;
      default = [ "::1" "127.0.0.1" ];
      description = ''
        What addresses the server should listen on. (UDP+TCP 53)
      '';
    };
    listenTLS = mkOption {
      type = with types; listOf str;
      default = [];
      example = [ "198.51.100.1:853" "[2001:db8::1]:853" "853" ];
      description = ''
        Addresses on which kresd should provide DNS over TLS (see RFC 7858).
        For detailed syntax see ListenStream in man systemd.socket.
      '';
    };
    # TODO: perhaps options for more common stuff like cache size or forwarding
  };

  ###### implementation
  config = mkIf cfg.enable {
    environment.etc."kresd.conf".source = configFile; # not required

    users.users = singleton
      { name = "kresd";
        uid = config.ids.uids.kresd;
        group = "kresd";
        description = "Knot-resolver daemon user";
      };
    users.groups = singleton
      { name = "kresd";
        gid = config.ids.gids.kresd;
      };

    systemd.sockets.kresd = rec {
      wantedBy = [ "sockets.target" ];
      before = wantedBy;
      listenStreams = map
        # Syntax depends on being IPv6 or IPv4.
        (iface: if elem ":" (stringToCharacters iface) then "[${iface}]:53" else "${iface}:53")
        cfg.interfaces;
      socketConfig = {
        ListenDatagram = listenStreams;
        FreeBind = true;
        FileDescriptorName = "dns";
      };
    };

    systemd.sockets.kresd-tls = mkIf (cfg.listenTLS != []) rec {
      wantedBy = [ "sockets.target" ];
      before = wantedBy;
      partOf = [ "kresd.socket" ];
      listenStreams = cfg.listenTLS;
      socketConfig = {
        FileDescriptorName = "tls";
        FreeBind = true;
        Service = "kresd.service";
      };
    };

    systemd.sockets.kresd-control = rec {
      wantedBy = [ "sockets.target" ];
      before = wantedBy;
      partOf = [ "kresd.socket" ];
      listenStreams = [ "/run/kresd/control" ];
      socketConfig = {
        FileDescriptorName = "control";
        Service = "kresd.service";
        SocketMode = "0660"; # only root user/group may connect and control kresd
      };
    };

    systemd.tmpfiles.rules = [ "d '${cfg.cacheDir}' 0770 kresd kresd - -" ];

    systemd.services.kresd = {
      description = "Knot-resolver daemon";

      serviceConfig = {
        User = "kresd";
        Type = "notify";
        WorkingDirectory = cfg.cacheDir;
        Restart = "on-failure";
        Sockets = [ "kresd.socket" "kresd-control.socket" ]
          ++ optional (cfg.listenTLS != []) "kresd-tls.socket";
      };

      # Trust anchor goes from dns-root-data by default.
      script = ''
        exec '${package}/bin/kresd' --config '${configFile}' --forks=1
      '';

      requires = [ "kresd.socket" ];
    };
  };
}
