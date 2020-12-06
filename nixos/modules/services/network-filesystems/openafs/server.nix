{ config, lib, pkgs, ... }:

# openafsBin, openafsSrv, mkCellServDB
with import ./lib.nix { inherit config lib pkgs; };

let
  inherit (lib) concatStringsSep mkIf mkOption optionalString types;

  bosConfig = pkgs.writeText "BosConfig" (''
    restrictmode 1
    restarttime 16 0 0 0 0
    checkbintime 3 0 5 0 0
  '' + (optionalString cfg.roles.database.enable ''
    bnode simple vlserver 1
    parm ${openafsSrv}/libexec/openafs/vlserver ${optionalString cfg.dottedPrincipals "-allow-dotted-principals"} ${cfg.roles.database.vlserverArgs}
    end
    bnode simple ptserver 1
    parm ${openafsSrv}/libexec/openafs/ptserver ${optionalString cfg.dottedPrincipals "-allow-dotted-principals"} ${cfg.roles.database.ptserverArgs}
    end
  '') + (optionalString cfg.roles.fileserver.enable ''
    bnode dafs dafs 1
    parm ${openafsSrv}/libexec/openafs/dafileserver ${optionalString cfg.dottedPrincipals "-allow-dotted-principals"} -udpsize ${udpSizeStr} ${cfg.roles.fileserver.fileserverArgs}
    parm ${openafsSrv}/libexec/openafs/davolserver ${optionalString cfg.dottedPrincipals "-allow-dotted-principals"} -udpsize ${udpSizeStr} ${cfg.roles.fileserver.volserverArgs}
    parm ${openafsSrv}/libexec/openafs/salvageserver ${cfg.roles.fileserver.salvageserverArgs}
    parm ${openafsSrv}/libexec/openafs/dasalvager ${cfg.roles.fileserver.salvagerArgs}
    end
  '') + (optionalString (cfg.roles.database.enable && cfg.roles.backup.enable) ''
    bnode simple buserver 1
    parm ${openafsSrv}/libexec/openafs/buserver ${cfg.roles.backup.buserverArgs} ${optionalString (cfg.roles.backup.cellServDB != []) "-cellservdb /etc/openafs/backup/"}
    end
  ''));

  netInfo = if (cfg.advertisedAddresses != []) then
    pkgs.writeText "NetInfo" ((concatStringsSep "\nf " cfg.advertisedAddresses) + "\n")
  else null;

  buCellServDB = pkgs.writeText "backup-cellServDB-${cfg.cellName}" (mkCellServDB cfg.cellName cfg.roles.backup.cellServDB);

  cfg = config.services.openafsServer;

  udpSizeStr = toString cfg.udpPacketSize;

in {

  options = {

    services.openafsServer = {

      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to enable the OpenAFS server. An OpenAFS server needs a
          complex setup. So, be aware that enabling this service and setting
          some options does not give you a turn-key-ready solution. You need
          at least a running Kerberos 5 setup, as OpenAFS relies on it for
          authentication. See the Guide "QuickStartUnix" coming with
          <literal>pkgs.openafs.doc</literal> for complete setup
          instructions.
        '';
      };

      advertisedAddresses = mkOption {
        default = [];
        description = "List of IP addresses this server is advertised under. See NetInfo(5)";
      };

      cellName = mkOption {
        default = "";
        type = types.str;
        description = "Cell name, this server will serve.";
        example = "grand.central.org";
      };

      cellServDB = mkOption {
        default = [];
        type = with types; listOf (submodule [ { options = cellServDBConfig;} ]);
        description = "Definition of all cell-local database server machines.";
      };

      package = mkOption {
        default = pkgs.openafs.server or pkgs.openafs;
        defaultText = "pkgs.openafs.server or pkgs.openafs";
        type = types.package;
        description = "OpenAFS package for the server binaries";
      };

      roles = {
        fileserver = {
          enable = mkOption {
            default = true;
            type = types.bool;
            description = "Fileserver role, serves files and volumes from its local storage.";
          };

          fileserverArgs = mkOption {
            default = "-vattachpar 128 -vhashsize 11 -L -rxpck 400 -cb 1000000";
            type = types.str;
            description = "Arguments to the dafileserver process. See its man page.";
          };

          volserverArgs = mkOption {
            default = "";
            type = types.str;
            description = "Arguments to the davolserver process. See its man page.";
            example = "-sync never";
          };

          salvageserverArgs = mkOption {
            default = "";
            type = types.str;
            description = "Arguments to the salvageserver process. See its man page.";
            example = "-showlog";
          };

          salvagerArgs = mkOption {
            default = "";
            type = types.str;
            description = "Arguments to the dasalvager process. See its man page.";
            example = "-showlog -showmounts";
          };
        };

        database = {
          enable = mkOption {
            default = true;
            type = types.bool;
            description = ''
              Database server role, maintains the Volume Location Database,
              Protection Database (and Backup Database, see
              <literal>backup</literal> role). There can be multiple
              servers in the database role for replication, which then need
              reliable network connection to each other.

              Servers in this role appear in AFSDB DNS records or the
              CellServDB.
            '';
          };

          vlserverArgs = mkOption {
            default = "";
            type = types.str;
            description = "Arguments to the vlserver process. See its man page.";
            example = "-rxbind";
          };

          ptserverArgs = mkOption {
            default = "";
            type = types.str;
            description = "Arguments to the ptserver process. See its man page.";
            example = "-restricted -default_access S---- S-M---";
          };
        };

        backup = {
          enable = mkOption {
            default = false;
            type = types.bool;
            description = ''
              Backup server role. Use in conjunction with the
              <literal>database</literal> role to maintain the Backup
              Database. Normally only used in conjunction with tape storage
              or IBM's Tivoli Storage Manager.
            '';
          };

          buserverArgs = mkOption {
            default = "";
            type = types.str;
            description = "Arguments to the buserver process. See its man page.";
            example = "-p 8";
          };

          cellServDB = mkOption {
            default = [];
            type = with types; listOf (submodule [ { options = cellServDBConfig;} ]);
            description = ''
              Definition of all cell-local backup database server machines.
              Use this when your cell uses less backup database servers than
              other database server machines.
            '';
          };
        };
      };

      dottedPrincipals= mkOption {
        default = false;
        type = types.bool;
        description = ''
          If enabled, allow principal names containing (.) dots. Enabling
          this has security implications!
        '';
      };

      udpPacketSize = mkOption {
        default = 1310720;
        type = types.int;
        description = ''
          UDP packet size to use in Bytes. Higher values can speed up
          communications. The default of 1 MB is a sufficient in most
          cases. Make sure to increase the kernel's UDP buffer size
          accordingly via <literal>net.core(w|r|opt)mem_max</literal>
          sysctl.
        '';
      };

    };

  };

  config = mkIf cfg.enable {

    assertions = [
      { assertion = cfg.cellServDB != [];
        message = "You must specify all cell-local database servers in config.services.openafsServer.cellServDB.";
      }
      { assertion = cfg.cellName != "";
        message = "You must specify the local cell name in config.services.openafsServer.cellName.";
      }
    ];

    environment.systemPackages = [ openafsBin ];

    environment.etc = {
      bosConfig = {
        source = bosConfig;
        target = "openafs/BosConfig";
        mode = "0644";
      };
      cellServDB = {
        text = mkCellServDB cfg.cellName cfg.cellServDB;
        target = "openafs/server/CellServDB";
        mode = "0644";
      };
      thisCell = {
        text = cfg.cellName;
        target = "openafs/server/ThisCell";
        mode = "0644";
      };
      buCellServDB = {
        enable = (cfg.roles.backup.cellServDB != []);
        text = mkCellServDB cfg.cellName cfg.roles.backup.cellServDB;
        target = "openafs/backup/CellServDB";
      };
    };

    systemd.services = {
      openafs-server = {
        description = "OpenAFS server";
        after = [ "syslog.target" "network.target" ];
        wantedBy = [ "multi-user.target" ];
        restartIfChanged = false;
        unitConfig.ConditionPathExists = [
          "|/etc/openafs/server/KeyFileExt"
        ];
        preStart = ''
          mkdir -m 0755 -p /var/openafs
          ${optionalString (netInfo != null) "cp ${netInfo} /var/openafs/netInfo"}
          ${optionalString (cfg.roles.backup.cellServDB != []) "cp ${buCellServDB}"}
        '';
        serviceConfig = {
          ExecStart = "${openafsBin}/bin/bosserver -nofork";
          ExecStop = "${openafsBin}/bin/bos shutdown localhost -wait -localauth";
        };
      };
    };
  };
}
