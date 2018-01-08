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
        What addresses the server should listen on.
      '';
    };
    # TODO: perhaps options for more common stuff like cache size or forwarding
  };

  ###### implementation
  config = mkIf cfg.enable {
    environment.etc."kresd.conf".source = configFile; # not required

    users.extraUsers = singleton
      { name = "kresd";
        uid = config.ids.uids.kresd;
        group = "kresd";
        description = "Knot-resolver daemon user";
      };
    users.extraGroups = singleton
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
      socketConfig.ListenDatagram = listenStreams;
    };

    systemd.sockets.kresd-control = rec {
      wantedBy = [ "sockets.target" ];
      before = wantedBy;
      partOf = [ "kresd.socket" ];
      listenStreams = [ "/run/kresd/control" ];
      socketConfig = {
        FileDescriptorName = "control";
        Service = "kresd.service";
        SocketMode = "0660"; # only root user/group may connect
      };
    };

    # Create the cacheDir; tmpfiles don't work on nixos-rebuild switch.
    systemd.services.kresd-cachedir = {
      serviceConfig.Type = "oneshot";
      script = ''
        if [ ! -d '${cfg.cacheDir}' ]; then
          mkdir -p '${cfg.cacheDir}'
          chown kresd:kresd '${cfg.cacheDir}'
        fi
      '';
    };

    systemd.services.kresd = {
      description = "Knot-resolver daemon";

      serviceConfig = {
        User = "kresd";
        Type = "notify";
        WorkingDirectory = cfg.cacheDir;
      };

      script = ''
        exec '${package}/bin/kresd' --config '${configFile}' \
          -k '${cfg.cacheDir}/root.key'
      '';

      after = [ "kresd-cachedir.service" ];
      requires = [ "kresd.socket" "kresd-cachedir.service" ];
    };
  };
}
