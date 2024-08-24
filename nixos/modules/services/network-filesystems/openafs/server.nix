{
  config,
  lib,
  pkgs,
  ...
}:

# openafsBin, openafsSrv, mkCellServDB
with import ./lib.nix { inherit config lib pkgs; };

let
  inherit (lib)
    concatStringsSep
    literalExpression
    mkIf
    mkOption
    mkEnableOption
    mkPackageOption
    optionalString
    types
    ;

  bosConfig = pkgs.writeText "BosConfig" (
    ''
      restrictmode 1
      restarttime 16 0 0 0 0
      checkbintime 3 0 5 0 0
    ''
    + (optionalString cfg.roles.database.enable ''
      bnode simple vlserver 1
      parm ${openafsSrv}/libexec/openafs/vlserver ${optionalString cfg.dottedPrincipals "-allow-dotted-principals"} ${cfg.roles.database.vlserverArgs}
      end
      bnode simple ptserver 1
      parm ${openafsSrv}/libexec/openafs/ptserver ${optionalString cfg.dottedPrincipals "-allow-dotted-principals"} ${cfg.roles.database.ptserverArgs}
      end
    '')
    + (optionalString cfg.roles.fileserver.enable ''
      bnode dafs dafs 1
      parm ${openafsSrv}/libexec/openafs/dafileserver ${optionalString cfg.dottedPrincipals "-allow-dotted-principals"} -udpsize ${udpSizeStr} ${cfg.roles.fileserver.fileserverArgs}
      parm ${openafsSrv}/libexec/openafs/davolserver ${optionalString cfg.dottedPrincipals "-allow-dotted-principals"} -udpsize ${udpSizeStr} ${cfg.roles.fileserver.volserverArgs}
      parm ${openafsSrv}/libexec/openafs/salvageserver ${cfg.roles.fileserver.salvageserverArgs}
      parm ${openafsSrv}/libexec/openafs/dasalvager ${cfg.roles.fileserver.salvagerArgs}
      end
    '')
    + (optionalString
      (cfg.roles.database.enable && cfg.roles.backup.enable && (!cfg.roles.backup.enableFabs))
      ''
        bnode simple buserver 1
        parm ${openafsSrv}/libexec/openafs/buserver ${cfg.roles.backup.buserverArgs} ${optionalString useBuCellServDB "-cellservdb /etc/openafs/backup/"}
        end
      ''
    )
    + (optionalString
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
      pkgs.writeText "NetInfo" ((concatStringsSep "\nf " cfg.advertisedAddresses) + "\n")
    else
      null;

  buCellServDB = pkgs.writeText "backup-cellServDB-${cfg.cellName}" (
    mkCellServDB cfg.cellName cfg.roles.backup.cellServDB
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

  asetkeyScript =
    let
      cfgAuth = cfg.authentication;

      # Values taken from krb5/krb5.h
      krb5Enctypes = {
        des-cbc-crc = 1;
        des-cbc-md4 = 2;
        des-cbc-md5 = 3;
        des-cbc-raw = 4;
        des3-cbc-sha = 5;
        des3-cbc-raw = 6;
        des-hmac-sha1 = 8;
        dsa-sha1-cms = 9;
        md5-rsa-cms = 10;
        sha1-rsa-cms = 11;
        rc2-cbc-env = 12;
        rsa-env = 13;
        rsa-es-oaep-env = 14;
        des3-cbc-env = 15;
        des3-cbc-sha1 = 16;
        aes128-cts-hmac-sha1-96 = 17;
        aes256-cts-hmac-sha1-96 = 18;
        aes128-cts-hmac-sha256-128 = 19;
        aes256-cts-hmac-sha384-192 = 20;
        arcfour-hmac = 23;
        arcfour-hmac-exp = 24;
        camellia128-cts-cmac = 25;
        camellia256-cts-cmac = 26;
      };

      # Stringified Awk array et["<type name>"] = <type id> of known encryption types
      enctypeAwkArray = lib.concatStringsSep "\n" (
        lib.mapAttrsToList (t: n: ''et["${t}"] = ${toString n}'') krb5Enctypes
      );

      # Awk script that, given some Kerberos 5 key metadata in the format
      # printed by ktutil's list command, extracts the key version number (KVNO)
      # and encryption type of each key, converts the encryption type into a
      # numeric value understood by asetkey, and uses this information to
      # initialize the KeyFileExt database for OpenAFS.
      awkAsetkeyScript = pkgs.writeText "asetkey-script.awk" ''
        BEGIN {
            ${enctypeAwkArray}
            present = 0
        }

        # Skip over the table header and only match the configured service
        # principal
        (NR > 2) && ($3 == "${cfgAuth.principal}") {
            kvno = $2
            princ = $3
            # The encryption type returned by ktutil is surrounded by parentheses
            enctype = et[substr($4, 2, length($4)-2)]

            # Import each key into the KeyFileExt database
            system("${openafsBin}/bin/asetkey add rxkad_krb5 " kvno " " enctype " ${cfgAuth.keytab} " princ)

            # Signal that at least one key has been found for the given principal
            present = 1
        }

        END {
            # If the AFS principal could not be found anywhere in the keytab, error out
            if (0 == present) {
               print "ERROR: no key found for principal ${cfgAuth.principal} in keytab ${cfgAuth.keytab}"
               exit 1
            }
        }
      '';
    in
    # The AWK script above only works with the MIT Kerberos version of
    # ktutil. Please, do not override the ktutil binary with the Heimdal version
    # without first extending the AWK script to handle its different output
    # syntax.
    pkgs.writeShellScript "asetkey-script.sh" ''
      set -eo pipefail

      echo -e "rkt ${cfgAuth.keytab}\nlist -e" | ${pkgs.krb5}/bin/ktutil | \
        ${pkgs.gawk}/bin/awk -f ${awkAsetkeyScript}
    '';
in
{

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
          `pkgs.openafs.doc` for complete setup
          instructions.
        '';
      };

      advertisedAddresses = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "List of IP addresses this server is advertised under. See {manpage}`NetInfo(5)`";
      };

      cellName = mkOption {
        default = "";
        type = types.str;
        description = "Cell name, this server will serve.";
        example = "grand.central.org";
      };

      cellServDB = mkOption {
        default = [ ];
        type = with types; listOf (submodule [ { options = cellServDBConfig; } ]);
        description = "Definition of all cell-local database server machines.";
      };

      authentication = {
        principal =
          let
            defaultRealmPath = "security.krb5.settings.libdefaults.default_realm";
            defaultRealm = config."${defaultRealmPath}";
          in
          mkOption {
            default = "afs/${cfg.cellName}@${defaultRealm}";
            defaultText = literalExpression "afs/\${config.openafsServer.cellName}>@\${config.${defaultRealmPath}}";
            type = types.str;
            description = ''
              The full Kerberos 5 service principal used by the AFS server.

              This setting has no effect if
              {option}`services.openafsServer.authentication.keytab` is unset or
              set to null.
            '';
            example = "afs/grand.central.org@GRAND.CENTRAL.ORG";
          };

        keytab = mkOption {
          default = null;
          type = types.nullOr types.str;
          description = ''
            Path to a Kerberos 5 keytab containing the service keys used by the
            AFS cell. If null, use the {file}`/etc/openafs/server/KeyFileExt`
            keyring that is already present (see {manpage}`KeyFileExt(5)`).

            :::{.warning}
            Setting this option to a value other than null results in the deletion
            of any pre-existing {file}`/etc/openafs/server/KeyFileExt` file right
            before the AFS service is started.
            :::
          '';
          example = "/etc/krb5.keytab";
        };
      };

      package = mkPackageOption pkgs "openafs" { };

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
              `backup` role). There can be multiple
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
          enable = mkEnableOption ''
            the backup server role. When using OpenAFS built-in buserver, use in conjunction with the
            `database` role to maintain the Backup
            Database. Normally only used in conjunction with tape storage
            or IBM's Tivoli Storage Manager.

            For a modern backup server, enable this role and see
            {option}`enableFabs`
          '';

          enableFabs = mkEnableOption ''
            FABS, the flexible AFS backup system. It stores volumes as dump files, relying on other
            pre-existing backup solutions for handling them
          '';

          buserverArgs = mkOption {
            default = "";
            type = types.str;
            description = "Arguments to the buserver process. See its man page.";
            example = "-p 8";
          };

          cellServDB = mkOption {
            default = [ ];
            type = with types; listOf (submodule [ { options = cellServDBConfig; } ]);
            description = ''
              Definition of all cell-local backup database server machines.
              Use this when your cell uses less backup database servers than
              other database server machines.
            '';
          };

          fabsArgs = mkOption {
            default = "";
            type = types.str;
            description = ''
              Arguments to the fabsys process. See
              {manpage}`fabsys_server(1)` and
              {manpage}`fabsys_config(1)`.
            '';
          };

          fabsExtraConfig = mkOption {
            default = { };
            type = types.attrs;
            description = ''
              Additional configuration parameters for the FABS backup server.
            '';
            example = literalExpression ''
              {
                afs.localauth = true;
                afs.keytab = config.sops.secrets.fabsKeytab.path;
              }
            '';
          };
        };
      };

      dottedPrincipals = mkOption {
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
          accordingly via `net.core(w|r|opt)mem_max`
          sysctl.
        '';
      };

    };

  };

  config = mkIf cfg.enable {

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
        enable = useBuCellServDB;
        text = mkCellServDB cfg.cellName cfg.roles.backup.cellServDB;
        target = "openafs/backup/CellServDB";
      };
    };

    systemd.services = {
      openafs-server = {
        description = "OpenAFS server";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        restartIfChanged = false;
        unitConfig.ConditionPathExists = mkIf (cfg.authentication.keytab == null) [
          "|/etc/openafs/server/KeyFileExt"
        ];
        preStart =
          ''
            mkdir -m 0755 -p /var/openafs
            ${optionalString (netInfo != null) "cp ${netInfo} /var/openafs/netInfo"}
            ${optionalString useBuCellServDB "cp ${buCellServDB}"}
          ''
          + lib.optionalString (cfg.authentication.keytab != null) ''
            rm -f /etc/openafs/server/KeyFileExt
            ${asetkeyScript}
          '';
        serviceConfig = {
          ExecStart = "${openafsBin}/bin/bosserver -nofork";
          ExecStop = "${openafsBin}/bin/bos shutdown localhost -wait -localauth";
        };
      };
    };
  };
}
