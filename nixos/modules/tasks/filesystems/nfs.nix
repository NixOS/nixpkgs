{ config, lib, pkgs, ... }:

with lib;

let

  inInitrd = any (fs: fs == "nfs") config.boot.initrd.supportedFilesystems;

  nfsStateDir = "/var/lib/nfs";

  rpcMountpoint = "${nfsStateDir}/rpc_pipefs";

  format = pkgs.formats.ini {};

  idmapdConfFile = format.generate "idmapd.conf" cfg.idmapd.settings;
  nfsConfFile = pkgs.writeText "nfs.conf" cfg.extraConfig;
  requestKeyConfFile = pkgs.writeText "request-key.conf" ''
    create id_resolver * * ${pkgs.nfs-utils}/bin/nfsidmap -t 600 %k %d
  '';

  cfg = config.services.nfs;

in

{
  ###### interface

  options = {
    services.nfs = {
      idmapd.settings = mkOption {
        type = format.type;
        default = {};
        description = ''
          libnfsidmap configuration. Refer to
          <link xlink:href="https://linux.die.net/man/5/idmapd.conf"/>
          for details.
        '';
        example = literalExample ''
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
      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra nfs-utils configuration.
        '';
      };
    };
  };

  ###### implementation

  config = mkIf (any (fs: fs == "nfs" || fs == "nfs4") config.boot.supportedFilesystems) {

    services.rpcbind.enable = true;

    services.nfs.idmapd.settings = {
      General = mkMerge [
        { Pipefs-Directory = rpcMountpoint; }
        (mkIf (config.networking.domain != null) { Domain = config.networking.domain; })
      ];
      Mapping = {
        Nobody-User = "nobody";
        Nobody-Group = "nogroup";
      };
      Translation = {
        Method = "nsswitch";
      };
    };

    system.fsPackages = [ pkgs.nfs-utils ];

    boot.initrd.kernelModules = mkIf inInitrd [ "nfs" ];

    systemd.packages = [ pkgs.nfs-utils ];

    environment.systemPackages = [ pkgs.keyutils ];

    environment.etc = {
      "idmapd.conf".source = idmapdConfFile;
      "nfs.conf".source = nfsConfFile;
      "request-key.conf".source = requestKeyConfFile;
    };

    systemd.services.nfs-blkmap =
      { restartTriggers = [ nfsConfFile ];
      };

    systemd.targets.nfs-client =
      { wantedBy = [ "multi-user.target" "remote-fs.target" ];
      };

    systemd.services.nfs-idmapd =
      { restartTriggers = [ idmapdConfFile ];
      };

    systemd.services.nfs-mountd =
      { restartTriggers = [ nfsConfFile ];
        enable = mkDefault false;
      };

    systemd.services.nfs-server =
      { restartTriggers = [ nfsConfFile ];
        enable = mkDefault false;
      };

    systemd.services.auth-rpcgss-module =
      {
        unitConfig.ConditionPathExists = [ "" "/etc/krb5.keytab" ];
      };

    systemd.services.rpc-gssd =
      { restartTriggers = [ nfsConfFile ];
        unitConfig.ConditionPathExists = [ "" "/etc/krb5.keytab" ];
      };

    systemd.services.rpc-statd =
      { restartTriggers = [ nfsConfFile ];

        preStart =
          ''
            mkdir -p /var/lib/nfs/{sm,sm.bak}
          '';
      };

  };
}
