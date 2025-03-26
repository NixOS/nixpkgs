{ config, lib, options, pkgs, utils, ... }:
let
  cfg = config.services.amule;
  opt = options.services.amule;
  user = if cfg.user != null then cfg.user else "amule";
in

{

  ###### interface

  options = {

    services.amule = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to run the AMule daemon. You need to manually run "amuled --ec-config" to configure the service for the first time.
        '';
      };

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/home/${user}/";
        defaultText = lib.literalExpression ''
          "/home/''${config.${opt.user}}/"
        '';
        description = ''
          The directory holding configuration, incoming and temporary files.
        '';
      };

      user = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          The user the AMule daemon should run as.
        '';
      };

      package = lib.mkPackageOption pkgs "amule-daemon" { };

    };

  };


  ###### implementation

  config = lib.mkIf cfg.enable {

    users.users = lib.mkIf (cfg.user == null) [
      { name = "amule";
        description = "AMule daemon";
        group = "amule";
        uid = config.ids.uids.amule;
      } ];

    users.groups = lib.mkIf (cfg.user == null) [
      { name = "amule";
        gid = config.ids.gids.amule;
      } ];

    systemd.tmpfiles.settings."10-amuled".${cfg.dataDir}.d = {
      inherit (cfg) user group;
      mode = "0700";
    };

    systemd.services.amuled = {
      description = "AMule daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment.HOME = cfg.dataDir;

      serviceConfig = {
        User = "${cfg.user}";
        WorkingDirectory = cfg.dataDir;
        ExecStart = utils.escapeSystemdExecArgs [
          (lib.getExe' cfg.package "amuled")
          "--config-dir=${config.services.amule.dataDir}"
        ];
        Restart = "on-failure";
        RestartSec = "5s";

        # Hardening
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        DevicePolicy = "closed";
        ProtectSystem = "strict";
        ReadWritePaths = cfg.dataDir;
        ProtectHome = "tmpfs";
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = "AF_INET";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        LockPersonality = true;
      };
    };
  };
}
