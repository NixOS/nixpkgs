{ config, lib, pkgs, ... }:

with lib;

let

  inInitrd = config.boot.initrd.supportedFilesystems.nfs or false;

  nfsStateDir = "/var/lib/nfs";

  rpcMountpoint = "${nfsStateDir}/rpc_pipefs";

  format = pkgs.formats.ini {};

  idmapdConfFile = format.generate "idmapd.conf" cfg.idmapd.settings;

  # merge parameters from services.nfs.server
  nfsConfSettings =
    optionalAttrs (cfg.server.nproc != null) {
      nfsd.threads = cfg.server.nproc;
    } // optionalAttrs (cfg.server.hostName != null) {
      nfsd.host= cfg.hostName;
    } // optionalAttrs (cfg.server.mountdPort != null) {
      mountd.port = cfg.server.mountdPort;
    } // optionalAttrs (cfg.server.statdPort != null) {
      statd.port = cfg.server.statdPort;
    } // optionalAttrs (cfg.server.lockdPort != null) {
      lockd.port = cfg.server.lockdPort;
      lockd.udp-port = cfg.server.lockdPort;
    };

  nfsConfDeprecated = cfg.extraConfig + ''
    [nfsd]
    threads=${toString cfg.server.nproc}
    ${optionalString (cfg.server.hostName != null) "host=${cfg.server.hostName}"}
    ${cfg.server.extraNfsdConfig}

    [mountd]
    ${optionalString (cfg.server.mountdPort != null) "port=${toString cfg.server.mountdPort}"}

    [statd]
    ${optionalString (cfg.server.statdPort != null) "port=${toString cfg.server.statdPort}"}

    [lockd]
    ${optionalString (cfg.server.lockdPort != null) ''
      port=${toString cfg.server.lockdPort}
      udp-port=${toString cfg.server.lockdPort}
    ''}
  '';

  nfsConfFile =
    if cfg.settings != {}
    then format.generate "nfs.conf" (recursiveUpdate nfsConfSettings cfg.settings)
    else pkgs.writeText "nfs.conf" nfsConfDeprecated;

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
        description = lib.mdDoc ''
          libnfsidmap configuration. Refer to
          <https://linux.die.net/man/5/idmapd.conf>
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
      settings = mkOption {
        type = format.type;
        default = {};
        description = lib.mdDoc ''
          General configuration for NFS daemons and tools.
          See nfs.conf(5) and related man pages for details.
        '';
        example = literalExpression ''
          {
            mountd.manage-gids = true;
          }
        '';
      };
      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc ''
          Extra nfs-utils configuration.
        '';
      };
    };
  };

  ###### implementation

  config = mkIf (config.boot.supportedFilesystems.nfs or config.boot.supportedFilesystems.nfs4 or false) {

    warnings =
      (optional (cfg.extraConfig != "") ''
        `services.nfs.extraConfig` is deprecated. Use `services.nfs.settings` instead.
      '') ++ (optional (cfg.server.extraNfsdConfig != "") ''
        `services.nfs.server.extraNfsdConfig` is deprecated. Use `services.nfs.settings` instead.
      '');
    assertions = [{
      assertion = cfg.settings != {} -> cfg.extraConfig == "" && cfg.server.extraNfsdConfig == "";
      message = "`services.nfs.settings` cannot be used together with `services.nfs.extraConfig` and `services.nfs.server.extraNfsdConfig`.";
    }];

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
