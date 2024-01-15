{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.corosync;
in
{
  # interface
  options.services.corosync = {
    enable = mkEnableOption (lib.mdDoc "corosync");

    package = mkPackageOption pkgs "corosync" { };

    clusterName = mkOption {
      type = types.str;
      default = "nixcluster";
      description = lib.mdDoc "Name of the corosync cluster.";
    };

    extraOptions = mkOption {
      type = with types; listOf str;
      default = [];
      description = lib.mdDoc "Additional options with which to start corosync.";
    };

    nodelist = mkOption {
      description = lib.mdDoc "Corosync nodelist: all cluster members.";
      default = [];
      type = with types; listOf (submodule {
        options = {
          nodeid = mkOption {
            type = int;
            description = lib.mdDoc "Node ID number";
          };
          name = mkOption {
            type = str;
            description = lib.mdDoc "Node name";
          };
          ring_addrs = mkOption {
            type = listOf str;
            description = lib.mdDoc "List of addresses, one for each ring.";
          };
        };
      });
    };
  };

  # implementation
  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."corosync/corosync.conf".text = ''
      totem {
        version: 2
        secauth: on
        cluster_name: ${cfg.clusterName}
        transport: knet
      }

      nodelist {
        ${concatMapStrings ({ nodeid, name, ring_addrs }: ''
          node {
            nodeid: ${toString nodeid}
            name: ${name}
            ${concatStrings (imap0 (i: addr: ''
              ring${toString i}_addr: ${addr}
            '') ring_addrs)}
          }
        '') cfg.nodelist}
      }

      quorum {
        # only corosync_votequorum is supported
        provider: corosync_votequorum
        wait_for_all: 0
        ${optionalString (builtins.length cfg.nodelist < 3) ''
          two_node: 1
        ''}
      }

      logging {
        to_syslog: yes
      }
    '';

    environment.etc."corosync/uidgid.d/root".text = ''
      # allow pacemaker connection by root
      uidgid {
        uid: 0
        gid: 0
      }
    '';

    systemd.packages = [ cfg.package ];
    systemd.services.corosync = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        StateDirectory = "corosync";
        StateDirectoryMode = "0700";
      };
    };

    environment.etc."sysconfig/corosync".text = lib.optionalString (cfg.extraOptions != []) ''
      COROSYNC_OPTIONS="${lib.escapeShellArgs cfg.extraOptions}"
    '';
  };
}
