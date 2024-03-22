{ config, pkgs, lib, ... }:
let
  cfg = config.services.netbox-agent;
  settingsFormat = pkgs.formats.json {};
in {
  options.services.netbox-agent = {
    enable = lib.mkEnableOption "Netbox-agent";
    startAt = lib.mkOption {
      type = with lib.types; either str (listOf str);
      default = "*-*-* 00:00:00";
      description = ''
        Automatically start this unit at the given date/time, which
        must be in the format described in
        {manpage}`systemd.time(7)`.
      '';
    };
    randomizedDelaySec = lib.mkOption {
      default = "0";
      type = lib.types.str;
      example = "45min";
      description = ''
        Add a randomized delay before each netbox-agent runs.
        The delay will be chosen between zero and this value.
        This value must be a time span in the format specified by
        {manpage}`systemd.time(7)`
      '';
    };
    settings = lib.mkOption {
      type = settingsFormat.type;
      description = ''
        Settings to be passed to the netbox agent. Will be converted to a YAML
        config file
      '';
      default = {};
    };

    environmentFile = lib.mkOption {
      type = with lib.types; nullOr path;
      description = ''
        Environment file to pass to netbox-agent. See `netbox-agent --help` for
        possible environment variables
      '';
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.netbox-agent = {
      description = "Netbox-agent service. It generates an existing infrastructure on Netbox and have the ability to update it regularly through this service.";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      serviceConfig = {
        Type = "oneshot";
        # We could link directly into pkgs.tzdata, but at least timedatectl seems
        # to expect the symlink to point directly to a file in etc.
        # Setting the "debian timezone file" to point at /dev/null stops it doing anything.
        ExecStart = "${lib.getExe pkgs.netbox-agent} -c ${settingsFormat.generate "netbox-agent-config.yaml" cfg.settings}";
        EnvironmentFile = cfg.environmentFile;
        LockPersonality = true;
        MemoryDenyWriteExecute=true;
        NoNewPrivileges=true;
        PrivateTmp=true;
        ProtectControlGroups=true;
        ProtectHome=true;
        ProtectKernelModules=true;
        ProtectKernelTunables=true;
        ProtectSystem="strict";
        RestrictAddressFamilies="AF_UNIX AF_INET AF_INET6 AF_NETLINK";
        RestrictNamespaces=true;
        RestrictRealtime=true;
        RestrictSUIDSGID=true;
      };
      inherit (cfg) startAt;
    };
    systemd.timers.netbox-agent.timerConfig.RandomizedDelaySec = cfg.randomizedDelaySec;
  };

  meta.maintainers = with lib.maintainers; [ raitobezarius sinavir ];
}
