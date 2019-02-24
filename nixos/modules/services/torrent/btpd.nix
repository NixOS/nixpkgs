{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.btpd;
in {
  options = {
    services.btpd = {
      enable = mkEnableOption "the BitTorrent protocol daemon";

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/btpd";
        description = ''
          Base directory for btpd. State, logs, a socket, and torrent downloads are stored here.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "btpd";
        description = ''
          User which to run btpd as.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "btpd";
        description = ''
          Group which to run btpd as.
        '';
      };

      address = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          IP address to send to trackers.

          Null sends no address, so trackers will advertise the one they see btpd connect from.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 6681;
        description = ''
          Port for btpd to listen on.
        '';
      };

      ipv4 = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable IPv4 support for btpd.
        '';
      };

      ipv6 = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable IPv6 support for btpd.

          Note this section of
          <citerefentry>
            <refentrytitle>btpd</refentrytitle>
            <manvolnum>1</manvolnum>
          </citerefentry>:
          <quote>Unfortunately enabling both IPv6 and IPv4 in btpd is less
          useful than it should be. The problem is that some sites have
          trackers for both versions and it's likely that the IPv6 one,
          which probably has less peers, will be used in favour of the IPv4 one.</quote>
        '';
      };

      bandwidthLimitIn = mkOption {
        type = types.ints.unsigned;
        default = 0;
        description = ''
          Limit incoming BitTorrent traffic to n kB/s. 0 is unlimited.
        '';
      };

      bandwidthLimitOut = mkOption {
        type = types.ints.unsigned;
        default = 0;
        description = ''
          Limit outgoing BitTorrent traffic to n kB/s. 0 is unlimited.
        '';
      };

      emptyStart = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Start btpd without any active torrents.
        '';
      };

      ipcPermission = mkOption {
        type = types.ints.unsigned;
        default = 600;
        example = 666;
        description = ''
          Permission mode of the btpd socket.
        '';
      };

      maxPeers = mkOption {
        type = types.ints.unsigned;
        default = 0;
        description = ''
          Limit the amount of peers to n.
        '';
      };

      maxUploads = mkOption {
        type = types.int;
        default = -2;
        description = ''
          Controls the number of simultaneous uploads.
          The possible values are:
          <itemizedlist>
            <listitem><para>
              <literal>n &lt; -1</literal>: Choose n >= 2 based on bandwidthLimitOut (default).
            </para></listitem>
            <listitem><para>
              <literal>n = -1</literal>: Upload to every interested peer.
            </para></listitem>
            <listitem><para>
              <literal>n = 0</literal>: Don't upload to anyone.
            </para></listitem>
            <listitem><para>
              <literal>n &gt; 0</literal>: Upload to at most n peers simultaneously.
            </para></listitem>
          </itemizedlist>
        '';
      };

      prealloc = mkOption {
        type = types.ints.unsigned;
        default = 2048;
        description = ''
          Preallocate disk space in chunks of n kB.
          Note that n will be rounded up to the closest multiple of the
          torrent piece size. If n is zero no preallocation will be done.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.btpd ];

    users.users.btpd = mkIf (cfg.user == "btpd") { group = mkDefault cfg.group; };
    users.groups.btpd = mkIf (cfg.group == "btpd") { };

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} - ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.btpd = {
      after = [ "network.target" ];
      description = "BitTorrent Protocol Daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = ''
          ${pkgs.btpd}/bin/btpd \
              --no-daemon \
              -d ${escapeShellArg cfg.dataDir} \
              ${optionalString cfg.ipv4 "-4"} \
              ${optionalString cfg.ipv6 "-6"} \
              ${optionalString (cfg.address != null) "--ip ${cfg.address}"} \
              ${optionalString cfg.emptyStart "--empty-start"} \
              --bw-in ${toString cfg.bandwidthLimitIn} \
              --bw-out ${toString cfg.bandwidthLimitOut} \
              --ipcprot ${toString cfg.ipcPermission} \
              --max-peers ${toString cfg.maxPeers} \
              --max-uploads ${toString cfg.maxUploads} \
              --port ${toString cfg.port} \
              --prealloc ${toString cfg.prealloc}
        '';
      };
    };
  };

  meta.maintainers = with maintainers; [ tadeokondrak ];
}
