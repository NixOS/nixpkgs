{
  config,
  lib,
  pkgs,
  ...
}:

# openafsBin, openafsSrv, mkCellServDB

let
  openafsLib = import ./lib.nix { inherit config lib pkgs; };
  bosConfig = pkgs.writeText "BosConfig" (
    ''
      restrictmode 1
      restarttime 16 0 0 0 0
      checkbintime 3 0 5 0 0
    ''
    + (lib.optionalString cfg.roles.database.enable ''
      bnode simple vlserver 1
      parm ${openafsLib.openafsSrv}/libexec/openafs/vlserver ${lib.optionalString cfg.dottedPrincipals "-allow-dotted-principals"} ${cfg.roles.database.vlserverArgs}
      end
      bnode simple ptserver 1
      parm ${openafsLib.openafsSrv}/libexec/openafs/ptserver ${lib.optionalString cfg.dottedPrincipals "-allow-dotted-principals"} ${cfg.roles.database.ptserverArgs}
      end
    '')
    + (lib.optionalString cfg.roles.fileserver.enable ''
      bnode dafs dafs 1
      parm ${openafsLib.openafsSrv}/libexec/openafs/dafileserver ${lib.optionalString cfg.dottedPrincipals "-allow-dotted-principals"} -udpsize ${udpSizeStr} ${cfg.roles.fileserver.fileserverArgs}
      parm ${openafsLib.openafsSrv}/libexec/openafs/davolserver ${lib.optionalString cfg.dottedPrincipals "-allow-dotted-principals"} -udpsize ${udpSizeStr} ${cfg.roles.fileserver.volserverArgs}
      parm ${openafsLib.openafsSrv}/libexec/openafs/salvageserver ${cfg.roles.fileserver.salvageserverArgs}
      parm ${openafsLib.openafsSrv}/libexec/openafs/dasalvager ${cfg.roles.fileserver.salvagerArgs}
      end
    '')
    + (lib.optionalString
      (cfg.roles.database.enable && cfg.roles.backup.enable && (!cfg.roles.backup.enableFabs))
      ''
        bnode simple buserver 1
        parm ${openafsLib.openafsSrv}/libexec/openafs/buserver ${cfg.roles.backup.buserverArgs} ${lib.optionalString useBuCellServDB "-cellservdb /etc/openafs/backup/"}
        end
      ''
    )
    + (lib.optionalString
      (cfg.roles.database.enable && cfg.roles.backup.enable && cfg.roles.backup.enableFabs)
      ''
        bnode simple buserver 1
        parm ${lib.getBin pkgs.fabs}/bin/fabsys server --config ${fabsConfFile} ${cfg.roles.backup.fabsArgs}
        end
      ''
    )
  );

  netInfo =
    if (cfg.advertisedAddresses != [ ]) then
      pkgs.writeText "NetInfo" ((lib.concatStringsSep "\nf " cfg.advertisedAddresses) + "\n")
    else
      null;

  buCellServDB = pkgs.writeText "backup-cellServDB-${cfg.cellName}" (
    openafsLib.mkCellServDB cfg.cellName cfg.roles.backup.cellServDB
  );

  useBuCellServDB = (cfg.roles.backup.cellServDB != [ ]) && (!cfg.roles.backup.enableFabs);

  cfg = config.services.openafsServer;

  udpSizeStr = toString cfg.udpPacketSize;

  fabsConfFile = pkgs.writeText "fabs.yaml" (
    builtins.toJSON (
      {
        afs = {
          aklog = cfg.package + "/bin/aklog";
          cell = cfg.cellName;
          dumpscan = cfg.package + "/bin/afsdump_scan";
          fs = cfg.package + "/bin/fs";
          pts = cfg.package + "/bin/pts";
          vos = cfg.package + "/bin/vos";
        };
        k5start.command = (lib.getBin pkgs.kstart) + "/bin/k5start";
      }
      // cfg.roles.backup.fabsExtraConfig
    )
  );

in
{

  options = {

    services.openafsServer = {

      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to enable the OpenAFS server. An OpenAFS server needs a
          complex setup. So, be aware that enabling this service and setting
          some options does not give you a turn-key-ready solution. You need
          at least a running Kerberos 5 setup, as OpenAFS relies on it for
          authentication. See the Guide "QuickStartUnix" coming with
          `pkgs.openafs.doc` for complete setup
          instructions.
        '';
      };

      advertisedAddresses = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "List of IP addresses this server is advertised under. See NetInfo(5)";
      };

      cellName = lib.mkOption {
        default = "";
        type = lib.types.str;
        description = "Cell name, this server will serve.";
        example = "grand.central.org";
      };

      cellServDB = lib.mkOption {
        default = [ ];
        type = with lib.types; listOf (submodule [ { options = cellServDBConfig; } ]);
        description = "Definition of all cell-local database server machines.";
      };

      package = lib.mkPackageOption pkgs "openafs" { };

      roles = {
        fileserver = {
          enable = lib.mkOption {
            default = true;
            type = lib.types.bool;
            description = "Fileserver role, serves files and volumes from its local storage.";
          };

          fileserverArgs = lib.mkOption {
            default = "-vattachpar 128 -vhashsize 11 -L -rxpck 400 -cb 1000000";
            type = lib.types.str;
            description = "Arguments to the dafileserver process. See its man page.";
          };

          volserverArgs = lib.mkOption {
            default = "";
            type = lib.types.str;
            description = "Arguments to the davolserver process. See its man page.";
            example = "-sync never";
          };

          salvageserverArgs = lib.mkOption {
            default = "";
            type = lib.types.str;
            description = "Arguments to the salvageserver process. See its man page.";
            example = "-showlog";
          };

          salvagerArgs = lib.mkOption {
            default = "";
            type = lib.types.str;
            description = "Arguments to the dasalvager process. See its man page.";
            example = "-showlog -showmounts";
          };
        };

        database = {
          enable = lib.mkOption {
            default = true;
            type = lib.types.bool;
            description = ''
              Database server role, maintains the Volume Location Database,
              Protection Database (and Backup Database, see
              `backup` role). There can be multiple
              servers in the database role for replication, which then need
              reliable network connection to each other.

              Servers in this role appear in AFSDB DNS records or the
              CellServDB.
            '';
          };

          vlserverArgs = lib.mkOption {
            default = "";
            type = lib.types.str;
            description = "Arguments to the vlserver process. See its man page.";
            example = "-rxbind";
          };

          ptserverArgs = lib.mkOption {
            default = "";
            type = lib.types.str;
            description = "Arguments to the ptserver process. See its man page.";
            example = "-restricted -default_access S---- S-M---";
          };
        };

        backup = {
          enable = lib.mkEnableOption ''
            the backup server role. When using OpenAFS built-in buserver, use in conjunction with the
            `database` role to maintain the Backup
            Database. Normally only used in conjunction with tape storage
            or IBM's Tivoli Storage Manager.

            For a modern backup server, enable this role and see
            {option}`enableFabs`
          '';

          enableFabs = lib.mkEnableOption ''
            FABS, the flexible AFS backup system. It stores volumes as dump files, relying on other
            pre-existing backup solutions for handling them
          '';

          buserverArgs = lib.mkOption {
            default = "";
            type = lib.types.str;
            description = "Arguments to the buserver process. See its man page.";
            example = "-p 8";
          };

          cellServDB = lib.mkOption {
            default = [ ];
            type = with lib.types; listOf (submodule [ { options = cellServDBConfig; } ]);
            description = ''
              Definition of all cell-local backup database server machines.
              Use this when your cell uses less backup database servers than
              other database server machines.
            '';
          };

          fabsArgs = lib.mkOption {
            default = "";
            type = lib.types.str;
            description = ''
              Arguments to the fabsys process. See
              {manpage}`fabsys_server(1)` and
              {manpage}`fabsys_config(1)`.
            '';
          };

          fabsExtraConfig = lib.mkOption {
            default = { };
            type = lib.types.attrs;
            description = ''
              Additional configuration parameters for the FABS backup server.
            '';
            example = lib.literalExpression ''
              {
                afs.localauth = true;
                afs.keytab = config.sops.secrets.fabsKeytab.path;
              }
            '';
          };
        };
      };

      dottedPrincipals = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          If enabled, allow principal names containing (.) dots. Enabling
          this has security implications!
        '';
      };

      udpPacketSize = lib.mkOption {
        default = 1310720;
        type = lib.types.int;
        description = ''
          UDP packet size to use in Bytes. Higher values can speed up
          communications. The default of 1 MB is a sufficient in most
          cases. Make sure to increase the kernel's UDP buffer size
          accordingly via `net.core(w|r|opt)mem_max`
          sysctl.
        '';
      };

    };

  };

  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion = cfg.cellServDB != [ ];
        message = "You must specify all cell-local database servers in config.services.openafsServer.cellServDB.";
      }
      {
        assertion = cfg.cellName != "";
        message = "You must specify the local cell name in config.services.openafsServer.cellName.";
      }
    ];

    environment.systemPackages = [ openafsLib.openafsBin ];

    environment.etc = {
      bosConfig = {
        source = bosConfig;
        target = "openafs/BosConfig";
        mode = "0644";
      };
      cellServDB = {
        text = openafsLib.mkCellServDB cfg.cellName cfg.cellServDB;
        target = "openafs/server/CellServDB";
        mode = "0644";
      };
      thisCell = {
        text = cfg.cellName;
        target = "openafs/server/ThisCell";
        mode = "0644";
      };
      buCellServDB = {
        enable = useBuCellServDB;
        text = openafsLib.mkCellServDB cfg.cellName cfg.roles.backup.cellServDB;
        target = "openafs/backup/CellServDB";
      };
    };

    systemd.services = {
      openafs-server = {
        description = "OpenAFS server";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        restartIfChanged = false;
        unitConfig.ConditionPathExists = [
          "|/etc/openafs/server/KeyFileExt"
        ];
        preStart = ''
          mkdir -m 0755 -p /var/openafs
          ${lib.optionalString (netInfo != null) "cp ${netInfo} /var/openafs/netInfo"}
          ${lib.optionalString useBuCellServDB "cp ${buCellServDB}"}
        '';
        serviceConfig = {
          ExecStart = "${openafsLib.openafsBin}/bin/bosserver -nofork";
          ExecStop = "${openafsLib.openafsBin}/bin/bos shutdown localhost -wait -localauth";
        };
      };
    };
  };
}
