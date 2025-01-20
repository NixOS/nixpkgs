{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.portmaster;
  inherit (lib)
    mkOption
    mkEnableOption
    types
    mkIf
    optionalString
    maintainers
    ;
in
{
  options.services.portmaster = {
    enable = mkEnableOption "Portmaster Core Daemon";

    devmode.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        This option enables the Portmaster Core devmode.

        The devmode makes the Portmaster UI available at `127.0.0.1:817`.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "portmaster";
      description = ''
        The user to run Portmaster as.
      '';
    };

    group = mkOption {
      type = types.str;
      default = "portmaster";
      description = ''
        The group to run Portmaster under.
      '';
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/portmaster";
      description = ''
        The directory where Portmaster stores its data files.
      '';
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user} = {
      group = cfg.group;
      home = cfg.dataDir;
      createHome = true;
      isSystemUser = true;
      description = "Portmaster daemon user";
    };

    users.groups.${cfg.group}.gid = config.users.users.${cfg.user}.uid;

    systemd.services.portmaster = {
      enable = true;
      description = "Portmaster by Safing";
      documentation = [ "https://docs.safing.io" ];

      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      path = [ pkgs.iptables ];

      preStart = "${pkgs.portmaster}/bin/portmaster-start" + " --data \"${cfg.dataDir}\"" + " update";

      script =
        lib.getExe' pkgs.portmaster "portmaster-core"
        + " --data \"${cfg.dataDir}\""
        + optionalString cfg.devmode.enable " -devmode";

      postStop =
        lib.getExe' pkgs.portmaster "portmaster-start" + " --data \"${cfg.dataDir}\"" + " recover-iptables";

      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        RestartSec = "10";
        LockPersonality = "yes";
        MemoryDenyWriteExecute = "yes";
        NoNewPrivileges = "yes";
        User = cfg.user;
        Group = cfg.group;
        PrivateTmp = "yes";
        PIDFile = "${cfg.dataDir}/core-lock.pid";
        Environment = [ "LOGLEVEL=info" ];
        ProtectSystem = "true";
        ReadWritePaths = [ cfg.dataDir ];
        RestrictAddressFamilies = "AF_UNIX AF_NETLINK AF_INET AF_INET6";
        RestrictNamespaces = "yes";
        ProtectHome = "read-only";
        ProtectKernelTunables = "yes";
        ProtectKernelLogs = "yes";
        ProtectControlGroups = "yes";
        PrivateDevices = "yes";
        AmbientCapabilities = "cap_chown cap_kill cap_net_admin cap_net_bind_service cap_net_broadcast cap_net_raw cap_sys_module cap_sys_ptrace cap_dac_override cap_fowner cap_fsetid";
        CapabilityBoundingSet = "cap_chown cap_kill cap_net_admin cap_net_bind_service cap_net_broadcast cap_net_raw cap_sys_module cap_sys_ptrace cap_dac_override cap_fowner cap_fsetid";
        SystemCallArchitectures = "native";
        SystemCallFilter = "@system-service @module";
        SystemCallErrorNumber = "EPERM";
      };
    };
  };

  meta.maintainers = with maintainers; [
    nyanbinary
    sntx
  ];
}
