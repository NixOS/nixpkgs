{ config, lib, pkgs, ... }:

let
  inherit (lib)
    any optionalAttrs
    mkDefault mkIf mkMerge mkOption literalExpression types;

  inInitrd = any (fs: fs == "nfs") config.boot.initrd.supportedFilesystems;

  libDir = "/var/lib/nfs";

  rpcMountpoint = "${libDir}/rpc_pipefs";

  format = pkgs.formats.ini { };

  idmapdConfFile = format.generate "idmapd.conf" cfg.idmapd.settings;
  nfsConfFile = format.generate "nfs.conf" cfg.settings;
  requestKeyConfFile = pkgs.writeText "request-key.conf" ''
    create id_resolver * * ${pkgs.nfs-utils}/bin/nfsidmap -t 600 %k %d
  '';

  cfg = config.services.nfs;

in

{
  ###### interface

  options.services.nfs = {
    idmapd.settings = mkOption {
      type = format.type;
      default = { };
      description = ''
        libnfsidmap configuration. Refer to
        <link xlink:href="https://linux.die.net/man/5/idmapd.conf"/>
        for details.
      '';
      example = literalExpression ''
        {
          Translation = {
            GSS-Methods = "static,nsswitch";
          };
          Static = {
            "root/hostname.domain.com@REALM.COM" = "root";
          };
        }
      '';
    };

    settings = mkOption rec {
      type = format.type;
      default = { };
      description = ''
        Extra configuration options for /etc/nfs.conf.
      '';
    };
  };

  ###### implementation

  config = mkIf (any (fs: fs == "nfs" || fs == "nfs4") config.boot.supportedFilesystems) {

    services = {
      nfs.idmapd.settings = {
        General = {
          Pipefs-Directory = rpcMountpoint;
        }
        // optionalAttrs (config.networking.domain != null) { Domain = config.networking.domain; };
        Mapping = {
          Nobody-User = "nobody";
          Nobody-Group = "nogroup";
        };
        Translation = {
          Method = "nsswitch";
        };
      };
      rpcbind.enable = true;
    };

    system.fsPackages = [ pkgs.nfs-utils ];

    boot.initrd.kernelModules = mkIf inInitrd [ "nfs" ];

    environment = {
      etc = {
        "idmapd.conf".source = idmapdConfFile;
        "nfs.conf".source = nfsConfFile;
        "request-key.conf".source = requestKeyConfFile;
      };
      systemPackages = [ pkgs.keyutils ];
    };

    systemd = {
      packages = [ pkgs.nfs-utils ];

      services = {
        nfs-blkmap = {
          restartTriggers = [ nfsConfFile ];
        };

        nfs-idmapd = {
          restartTriggers = [ idmapdConfFile ];
        };

        nfs-mountd = {
          restartTriggers = [ nfsConfFile ];
          enable = mkDefault false;
        };

        nfs-server = {
          restartTriggers = [ nfsConfFile ];
          enable = mkDefault false;
        };

        auth-rpcgss-module = {
          unitConfig.ConditionPathExists = [ "" "/etc/krb5.keytab" ];
        };

        rpc-gssd = {
          restartTriggers = [ nfsConfFile ];
          unitConfig.ConditionPathExists = [ "" "/etc/krb5.keytab" ];
        };

        rpc-statd = {
          restartTriggers = [ nfsConfFile ];
        };
      };

      targets.nfs-client = {
        wantedBy = [ "multi-user.target" "remote-fs.target" ];
      };

      tmpfiles.rules = [
        "d ${libDir}/sm     0700 nobody root - -"
        "d ${libDir}/sm.bak 0700 nobody root - -"
        "d ${rpcMountpoint}      0555 - - - -"
      ];
    };
  };
}
