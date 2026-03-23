{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.corosync;
in
{
  # interface
  options.services.corosync = {
    enable = lib.mkEnableOption "corosync";

    package = lib.mkPackageOption pkgs "corosync" { };

    clusterName = lib.mkOption {
      type = lib.types.str;
      default = "nixcluster";
      description = "Name of the corosync cluster.";
    };

    extraOptions = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = "Additional options with which to start corosync.";
    };

    nodelist = lib.mkOption {
      description = "Corosync nodelist: all cluster members.";
      default = [ ];
      type =
        with lib.types;
        listOf (submodule {
          options = {
            nodeid = lib.mkOption {
              type = int;
              description = "Node ID number";
            };
            name = lib.mkOption {
              type = str;
              description = "Node name";
            };
            ring_addrs = lib.mkOption {
              type = listOf str;
              description = "List of addresses, one for each ring.";
            };
          };
        });
    };
  };

  # implementation
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."corosync/corosync.conf".text = ''
      totem {
        version: 2
        secauth: on
        cluster_name: ${cfg.clusterName}
        transport: knet
      }

      nodelist {
        ${lib.concatMapStrings (
          {
            nodeid,
            name,
            ring_addrs,
          }:
          ''
            node {
              nodeid: ${toString nodeid}
              name: ${name}
              ${lib.concatStrings (
                lib.imap0 (i: addr: ''
                  ring${toString i}_addr: ${addr}
                '') ring_addrs
              )}
            }
          ''
        ) cfg.nodelist}
      }

      quorum {
        # only corosync_votequorum is supported
        provider: corosync_votequorum
        wait_for_all: 0
        ${lib.optionalString (builtins.length cfg.nodelist < 3) ''
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

    environment.etc."sysconfig/corosync".text = lib.optionalString (cfg.extraOptions != [ ]) ''
      COROSYNC_OPTIONS="${lib.escapeShellArgs cfg.extraOptions}"
    '';
  };
}
