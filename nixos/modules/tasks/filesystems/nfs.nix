{
  config,
  lib,
  pkgs,
  ...
}:
let

  inInitrd = config.boot.initrd.supportedFilesystems.nfs or false;

  nfsStateDir = "/var/lib/nfs";

  rpcMountpoint = "${nfsStateDir}/rpc_pipefs";

  format = pkgs.formats.ini { };

  idmapdConfFile = format.generate "idmapd.conf" cfg.idmapd.settings;

  # merge parameters from services.nfs.server
  nfsConfSettings =
    lib.optionalAttrs (cfg.server.nproc != null) {
      nfsd.threads = cfg.server.nproc;
    }
    // lib.optionalAttrs (cfg.server.hostName != null) {
      nfsd.host = cfg.server.hostName;
    }
    // lib.optionalAttrs (cfg.server.mountdPort != null) {
      mountd.port = cfg.server.mountdPort;
    }
    // lib.optionalAttrs (cfg.server.statdPort != null) {
      statd.port = cfg.server.statdPort;
    }
    // lib.optionalAttrs (cfg.server.lockdPort != null) {
      lockd.port = cfg.server.lockdPort;
      lockd.udp-port = cfg.server.lockdPort;
    };

  nfsConfDeprecated = cfg.extraConfig + ''
    [nfsd]
    threads=${toString cfg.server.nproc}
    ${lib.optionalString (cfg.server.hostName != null) "host=${cfg.server.hostName}"}
    ${cfg.server.extraNfsdConfig}

    [mountd]
    ${lib.optionalString (cfg.server.mountdPort != null) "port=${toString cfg.server.mountdPort}"}

    [statd]
    ${lib.optionalString (cfg.server.statdPort != null) "port=${toString cfg.server.statdPort}"}

    [lockd]
    ${lib.optionalString (cfg.server.lockdPort != null) ''
      port=${toString cfg.server.lockdPort}
      udp-port=${toString cfg.server.lockdPort}
    ''}
  '';

  nfsConfFile =
    if cfg.settings != { } then
      format.generate "nfs.conf" (lib.recursiveUpdate nfsConfSettings cfg.settings)
    else
      pkgs.writeText "nfs.conf" nfsConfDeprecated;

  cfg = config.services.nfs;

in

{
  ###### interface

  options = {
    services.nfs = {
      idmapd.settings = lib.mkOption {
        type = format.type;
        default = { };
        description = ''
          libnfsidmap configuration. Refer to
          <https://linux.die.net/man/5/idmapd.conf>
          for details.
        '';
        example = lib.literalExpression ''
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
      settings = lib.mkOption {
        type = format.type;
        default = { };
        description = ''
          General configuration for NFS daemons and tools.
          See {manpage}`nfs.conf(5)` and related man pages for details.
        '';
        example = lib.literalExpression ''
          {
            mountd.manage-gids = true;
          }
        '';
      };
      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Extra nfs-utils configuration.
        '';
      };
    };
  };

  ###### implementation

  config =
    lib.mkIf (config.boot.supportedFilesystems.nfs or config.boot.supportedFilesystems.nfs4 or false)
      {

        warnings =
          (lib.optional (cfg.extraConfig != "") ''
            `services.nfs.extraConfig` is deprecated. Use `services.nfs.settings` instead.
          '')
          ++ (lib.optional (cfg.server.extraNfsdConfig != "") ''
            `services.nfs.server.extraNfsdConfig` is deprecated. Use `services.nfs.settings` instead.
          '');
        assertions = [
          {
            assertion = cfg.settings != { } -> cfg.extraConfig == "" && cfg.server.extraNfsdConfig == "";
            message = "`services.nfs.settings` cannot be used together with `services.nfs.extraConfig` and `services.nfs.server.extraNfsdConfig`.";
          }
        ];

        services.rpcbind.enable = true;

        services.nfs.idmapd.settings = {
          General = lib.mkMerge [
            { Pipefs-Directory = rpcMountpoint; }
            (lib.mkIf (config.networking.domain != null) { Domain = config.networking.domain; })
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

        boot.initrd.kernelModules = lib.mkIf inInitrd [ "nfs" ];

        systemd.packages = [ pkgs.nfs-utils ];

        environment.systemPackages = [ pkgs.keyutils ];

        environment.etc = {
          "idmapd.conf".source = idmapdConfFile;
          "nfs.conf".source = nfsConfFile;
          "request-key.conf".text = ''
            create id_resolver * * ${pkgs.nfs-utils}/bin/nfsidmap -t 600 %k %d
            create dns_resolver * * ${pkgs.keyutils}/bin/key.dns_resolver %k
          '';
        };

        systemd.services.nfs-blkmap = {
          restartTriggers = [ nfsConfFile ];
        };

        systemd.targets.nfs-client = {
          wantedBy = [
            "multi-user.target"
            "remote-fs.target"
          ];
        };

        systemd.services.nfs-idmapd = {
          restartTriggers = [ idmapdConfFile ];
        };

        systemd.services.nfs-mountd = {
          restartTriggers = [ nfsConfFile ];
          enable = lib.mkDefault false;
        };

        systemd.services.nfs-server = {
          restartTriggers = [ nfsConfFile ];
          enable = lib.mkDefault false;
        };

        systemd.services.auth-rpcgss-module = {
          unitConfig.ConditionPathExists = [
            ""
            "/etc/krb5.keytab"
          ];
        };

        systemd.services.rpc-gssd = {
          restartTriggers = [ nfsConfFile ];
          unitConfig.ConditionPathExists = [
            ""
            "/etc/krb5.keytab"
          ];
        };

        systemd.services.rpc-statd = {
          restartTriggers = [ nfsConfFile ];

          preStart = ''
            mkdir -p /var/lib/nfs/{sm,sm.bak}
          '';
        };

      };
}
