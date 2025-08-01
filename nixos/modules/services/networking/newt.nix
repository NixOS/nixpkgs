{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.newt;
in
{
  options = {
    services.newt = {
      enable = lib.mkEnableOption "Newt, user space tunnel client for Pangolin";
      # needs to be changed when newt-go changes to fosrl-newt
      package = lib.mkPackageOption pkgs "newt-go" { };

      id = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          The Newt Id that will be used to communicate to Pangolin. This is generated on site creation in the dashboard.
        '';
      };
      endpoint = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          The endpoint where both Gerbil and Pangolin reside in order to connect to the websocket. The url of your Pangolin dashboard.
        '';
      };
      logLevel = lib.mkOption {
        type = lib.types.enum [
          "DEBUG"
          "INFO"
          "WARN"
          "ERROR"
          "FATAL"
        ];
        default = "INFO";
        description = "The log level to use.";
      };
      # provide path to file to keep secrets out of the nix store
      environmentFile = lib.mkOption {
        type = with lib.types; nullOr path;
        default = null;
        description = ''
          Path to a file containing sensitive environment variables for Newt. See https://docs.fossorial.io/Newt/overview#cli-args
          These will overwrite anything defined in the config.
          The file should contain environment-variable assignments like:
          NEWT_ID=2ix2t8xk22ubpfy
          NEWT_SECRET=nnisrfsdfc7prqsp9ewo1dvtvci50j5uiqotez00dgap0ii2
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion = cfg.environmentFile != null;
        message = "services.newt.environmentFile must be provided when Newt is enabled.";
      }
    ];

    systemd.services.newt = {
      description = "Newt, user space tunnel client for Pangolin";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment = {
        HOME = "/var/lib/private/newt";
      };
      # the flag values will all be overwritten if also defined in the env file
      script = "
        exec ${lib.getExe pkgs.newt-go} \\\n
        ${lib.optionalString (
                !isNull cfg.id
              ) "--id ${cfg.id} \\\n"}
        ${lib.optionalString (
                !isNull cfg.endpoint
              ) "--endpoint ${cfg.endpoint} \\\n"}
        --log-level ${cfg.logLevel}
      ";
      serviceConfig = {
        DynamicUser = true;
        StateDirectory = "newt";
        StateDirectoryMode = "0700";
        Restart = "always";
        RestartSec = "10s";
        EnvironmentFile = cfg.environmentFile;
        # hardening
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = "disconnected";
        PrivateDevices = true;
        PrivateUsers = true;
        PrivateMounts = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        LockPersonality = true;
        RestrictRealtime = true;
        ProtectClock = true;
        ProtectProc = "noaccess";
        ProtectHostname = true;
        RemoveIPC = true;
        NoNewPrivileges = true;
        RestrictSUIDSGID = true;
        MemoryDenyWriteExecute = true;
        SystemCallArchitectures = "native";
        UMask = "0077";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
          "AF_UNIX"
        ];
        CapabilityBoundingSet = [
          "~CAP_BLOCK_SUSPEND"
          "~CAP_BPF"
          "~CAP_CHOWN"
          "~CAP_MKNOD"
          "~CAP_NET_RAW"
          "~CAP_PERFMON"
          "~CAP_SYS_BOOT"
          "~CAP_SYS_CHROOT"
          "~CAP_SYS_MODULE"
          "~CAP_SYS_NICE"
          "~CAP_SYS_PACCT"
          "~CAP_SYS_PTRACE"
          "~CAP_SYS_TIME"
          "~CAP_SYS_TTY_CONFIG"
          "~CAP_SYSLOG"
          "~CAP_WAKE_ALARM"
        ];
        SystemCallFilter = [
          "~@aio:EPERM"
          "~@chown:EPERM"
          "~@clock:EPERM"
          "~@cpu-emulation:EPERM"
          "~@debug:EPERM"
          "~@keyring:EPERM"
          "~@memlock:EPERM"
          "~@module:EPERM"
          "~@mount:EPERM"
          "~@obsolete:EPERM"
          "~@pkey:EPERM"
          "~@privileged:EPERM"
          "~@raw-io:EPERM"
          "~@reboot:EPERM"
          "~@resources:EPERM"
          "~@sandbox:EPERM"
          "~@setuid:EPERM"
          "~@swap:EPERM"
          "~@sync:EPERM"
          "~@timer:EPERM"
        ];
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ jackr ];
}
